// Reads block states from a world's Anvil region files (.mca)
import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { gunzipSync, inflateSync } from "node:zlib";
import { readNbt, type Nbt } from "./nbt";

type Compound = { [key: string]: Nbt };
type Section = { palette: string[]; data?: BigInt64Array };

// Chunks saved before 1.18 use another layout; open the world in a newer
// version to upgrade them
const MIN_DATA_VERSION = 2860;

// Where worlds saved before 26.x keep each dimension's region files
const LEGACY_DIRS: Record<string, string> = {
  "minecraft:overworld": "region",
  "minecraft:the_nether": join("DIM-1", "region"),
  "minecraft:the_end": join("DIM1", "region"),
};

export class World {
  private chunks = new Map<string, Map<number, Section> | null>();
  private regions = new Map<string, Buffer | null>();
  private regionDir: string;

  constructor(dir: string, dimension = "minecraft:overworld") {
    const match = /^([a-z0-9_.-]+):([a-z0-9_./-]+)$/.exec(dimension);
    if (!match) throw new Error(`bad dimension ${dimension}`);
    // 26.x: <world>/dimensions/<namespace>/<path>/region
    this.regionDir = join(dir, "dimensions", match[1], match[2], "region");
    if (!existsSync(this.regionDir) && LEGACY_DIRS[dimension]) this.regionDir = join(dir, LEGACY_DIRS[dimension]);
    // Otherwise a wrong path would look like a world with nothing saved
    if (!existsSync(this.regionDir)) throw new Error(`no region files for ${dimension} in ${dir}`);
  }

  /**
   * The block id at a position, or null if its chunk can't be read: never
   * saved, not fully generated, or saved before 1.18.
   */
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

  private region(rx: number, rz: number) {
    const key = `${rx},${rz}`;
    if (!this.regions.has(key)) {
      const file = join(this.regionDir, `r.${rx}.${rz}.mca`);
      this.regions.set(key, existsSync(file) ? readFileSync(file) : null);
    }
    return this.regions.get(key)!;
  }

  private load(cx: number, cz: number): Map<number, Section> | null {
    const region = this.region(cx >> 5, cz >> 5);
    if (!region) return null;
    const at = 4 * ((cx & 31) + (cz & 31) * 32);
    const offset = region.readUIntBE(at, 3) * 4096;
    if (offset === 0) return null;
    const length = region.readInt32BE(offset);
    const compression = region[offset + 4];
    // Chunks too big for the region file are stored beside it in c.<x>.<z>.mcc
    const body = compression & 128
      ? readFileSync(join(this.regionDir, `c.${cx}.${cz}.mcc`))
      : region.subarray(offset + 5, offset + 4 + length);
    const root = readNbt(decompress(body, compression & 127, cx, cz)) as Compound;
    if ((root.DataVersion as number) < MIN_DATA_VERSION) return null;
    // Chunks still being generated have partial terrain
    if (root.Status !== "minecraft:full" && root.Status !== "full") return null;
    const sections = new Map<number, Section>();
    for (const s of (root.sections ?? []) as Compound[]) {
      const states = s.block_states as Compound | undefined;
      if (!states) continue;
      const palette = (states.palette as Nbt[]).map(blockId);
      sections.set(s.Y as number, { palette, data: states.data as BigInt64Array | undefined });
    }
    return sections;
  }
}

function decompress(body: Buffer, compression: number, cx: number, cz: number) {
  if (compression === 1) return gunzipSync(body);
  if (compression === 2) return inflateSync(body);
  if (compression === 3) return body;
  throw new Error(`chunk ${cx},${cz} uses compression ${compression}, which isn't supported`);
}

/**
 * A palette entry's block id. 26.x saves a state without properties as a
 * bare string and one with properties as {id, properties}; older worlds use
 * {Name, Properties}.
 */
function blockId(entry: Nbt): string {
  if (typeof entry === "string") return entry;
  const c = entry as Compound;
  return (c.id ?? c.Name) as string;
}

export type Box = { x1: number; y1: number; z1: number; x2: number; y2: number; z2: number };

/** The box with each corner coordinate ordered low to high. */
export function normalize(box: Box): Box {
  for (const v of Object.values(box)) {
    if (!Number.isInteger(v)) throw new Error("box corners must be whole numbers");
  }
  return {
    x1: Math.min(box.x1, box.x2), y1: Math.min(box.y1, box.y2), z1: Math.min(box.z1, box.z2),
    x2: Math.max(box.x1, box.x2), y2: Math.max(box.y1, box.y2), z2: Math.max(box.z1, box.z2),
  };
}

const AIR = new Set(["minecraft:air", "minecraft:cave_air", "minecraft:void_air"]);
const MAX_VOLUME = 64 * 64 * 64;

/**
 * Counts each block in a box, and maps the top non-air block of each column
 * as a grid of letters (rows run north to south, from z1; columns west to
 * east, from x1).
 */
export function scan(world: World, box: Box) {
  const { x1, y1, z1, x2, y2, z2 } = normalize(box);
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
  let unreadable = 0;
  for (let z = z1; z <= z2; z++) {
    let row = "";
    for (let x = x1; x <= x2; x++) {
      let top: string | null = null;
      for (let y = y2; y >= y1; y--) {
        const id = world.block(x, y, z);
        if (id === null) {
          unreadable++;
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
  // Letter -> id, which reads better next to the grid. Past the last letter,
  // every further id shares "?"
  const key: Record<string, string | string[]> = {};
  for (const [id, l] of Object.entries(legend)) {
    if (l !== "?") key[l] = id;
    else key["?"] = [...((key["?"] as string[] | undefined) ?? []), id];
  }
  return {
    box: { x1, y1, z1, x2, y2, z2 },
    counts: sorted,
    top_view: { key, rows, empty: "." },
    // In chunks never saved, not fully generated, or saved before 1.18
    unreadable_blocks: unreadable,
  };
}
