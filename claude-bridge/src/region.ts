// Reads block states from a world's Anvil region files (.mca)
import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { gunzipSync, inflateSync } from "node:zlib";
import { readNbt, type Nbt } from "./nbt";

type Compound = { [key: string]: Nbt };
type Section = { palette: string[]; data?: BigInt64Array };

const DIMENSION_DIRS: Record<string, string> = {
  "minecraft:overworld": "region",
  "minecraft:the_nether": join("DIM-1", "region"),
  "minecraft:the_end": join("DIM1", "region"),
};

export class World {
  private chunks = new Map<string, Map<number, Section> | null>();

  constructor(private dir: string, private dimension = "minecraft:overworld") {
    if (!DIMENSION_DIRS[dimension]) throw new Error(`unknown dimension ${dimension}`);
  }

  /** The block id at a position, or null if its chunk was never saved. */
  block(x: number, y: number, z: number): string | null {
    const sections = this.chunk(x >> 4, z >> 4);
    if (!sections) return null;
    const section = sections.get(y >> 4);
    if (!section) return "minecraft:air";
    const { palette, data } = section;
    if (!data || palette.length === 1) return palette[0];
    const bits = Math.max(4, Math.ceil(Math.log2(palette.length)));
    // Entries never span two longs
    const perLong = Math.floor(64 / bits);
    const index = (((y & 15) * 16 + (z & 15)) * 16) + (x & 15);
    const long = data[Math.floor(index / perLong)];
    const shift = BigInt((index % perLong) * bits);
    const entry = Number((BigInt.asUintN(64, long) >> shift) & ((1n << BigInt(bits)) - 1n));
    return palette[entry] ?? "minecraft:air";
  }

  private chunk(cx: number, cz: number) {
    const key = `${cx},${cz}`;
    if (!this.chunks.has(key)) this.chunks.set(key, this.load(cx, cz));
    return this.chunks.get(key)!;
  }

  private load(cx: number, cz: number): Map<number, Section> | null {
    const file = join(this.dir, DIMENSION_DIRS[this.dimension], `r.${cx >> 5}.${cz >> 5}.mca`);
    if (!existsSync(file)) return null;
    const region = readFileSync(file);
    const at = 4 * ((cx & 31) + (cz & 31) * 32);
    const offset = region.readUIntBE(at, 3) * 4096;
    if (offset === 0) return null;
    const length = region.readInt32BE(offset);
    const compression = region[offset + 4];
    const body = region.subarray(offset + 5, offset + 4 + length);
    let raw: Buffer;
    if (compression === 1) raw = gunzipSync(body);
    else if (compression === 2) raw = inflateSync(body);
    else if (compression === 3) raw = body;
    else throw new Error(`chunk ${cx},${cz} uses compression ${compression}, which isn't supported`);
    const root = readNbt(raw) as Compound;
    const sections = new Map<number, Section>();
    for (const s of (root.sections ?? []) as Compound[]) {
      const states = s.block_states as Compound | undefined;
      if (!states) continue;
      const palette = (states.palette as Compound[]).map((p) => p.Name as string);
      sections.set(s.Y as number, { palette, data: states.data as BigInt64Array | undefined });
    }
    return sections;
  }
}

export type Box = { x1: number; y1: number; z1: number; x2: number; y2: number; z2: number };

const AIR = new Set(["minecraft:air", "minecraft:cave_air", "minecraft:void_air"]);
const MAX_VOLUME = 64 * 64 * 64;

/**
 * Counts each block in a box, and maps the top non-air block of each column
 * as a grid of letters (rows run north to south, from z1; columns west to
 * east, from x1).
 */
export function scan(world: World, box: Box) {
  const [x1, x2] = [Math.min(box.x1, box.x2), Math.max(box.x1, box.x2)];
  const [y1, y2] = [Math.min(box.y1, box.y2), Math.max(box.y1, box.y2)];
  const [z1, z2] = [Math.min(box.z1, box.z2), Math.max(box.z1, box.z2)];
  const volume = (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1);
  if (volume > MAX_VOLUME) throw new Error(`box is ${volume} blocks; the limit is ${MAX_VOLUME}`);

  const counts: Record<string, number> = {};
  const legend: Record<string, string> = {};
  const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  const letter = (id: string) => {
    if (!legend[id]) legend[id] = letters[Object.keys(legend).length] ?? "?";
    return legend[id];
  };
  const rows: string[] = [];
  let unsaved = 0;
  for (let z = z1; z <= z2; z++) {
    let row = "";
    for (let x = x1; x <= x2; x++) {
      let top: string | null = null;
      for (let y = y2; y >= y1; y--) {
        const id = world.block(x, y, z);
        if (id === null) {
          unsaved++;
          continue;
        }
        counts[id] = (counts[id] ?? 0) + 1;
        if (top === null && !AIR.has(id)) top = id;
      }
      row += top ? letter(top) : ".";
    }
    rows.push(row);
  }
  const sorted = Object.fromEntries(Object.entries(counts).sort((a, b) => b[1] - a[1]));
  // Letter -> id, which reads better next to the grid
  const key = Object.fromEntries(Object.entries(legend).map(([id, l]) => [l, id]));
  return { box: { x1, y1, z1, x2, y2, z2 }, counts: sorted, top_view: { key, rows, empty: "." }, unsaved_blocks: unsaved };
}
