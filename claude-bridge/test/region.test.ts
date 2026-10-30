import { afterAll, expect, test } from "bun:test";
import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { deflateSync } from "node:zlib";
import { World, scan } from "../src/region";

// Minimal NBT writer for building a test chunk
type W = ["byte", number] | ["int", number] | ["string", string] | ["longs", bigint[]] | ["list", W[]] | ["compound", Record<string, W>];
const TYPES = { byte: 1, int: 3, string: 8, list: 9, compound: 10, longs: 12 };
function payload([kind, v]: W): Buffer {
  switch (kind) {
    case "byte": return Buffer.from([v & 255]);
    case "int": { const b = Buffer.alloc(4); b.writeInt32BE(v); return b; }
    case "string": { const s = Buffer.from(v); const b = Buffer.alloc(2); b.writeUInt16BE(s.length); return Buffer.concat([b, s]); }
    case "longs": { const b = Buffer.alloc(4 + 8 * v.length); b.writeInt32BE(v.length); v.forEach((l, i) => b.writeBigInt64BE(BigInt.asIntN(64, l), 4 + 8 * i)); return b; }
    case "list": { const h = Buffer.alloc(5); h[0] = v.length ? TYPES[v[0][0]] : 0; h.writeInt32BE(v.length, 1); return Buffer.concat([h, ...v.map(payload)]); }
    case "compound": return Buffer.concat([...Object.entries(v).map(([k, w]) => Buffer.concat([Buffer.from([TYPES[w[0]]]), payload(["string", k]), payload(w)])), Buffer.from([0])]);
  }
}

// Chunk 0,0: section Y=4 (y 64-79) has stone at the bottom layer (y=64)
// except grass_block at x=1,z=0, and a sheep-less sky above
function chunk(legacy: boolean, status = "minecraft:full"): Buffer {
  const longs: bigint[] = new Array(256).fill(0n); // 4 bits, 16 per long
  for (let i = 0; i < 256; i++) {
    // index i in layer y=64: palette 1 (stone), except x=1,z=0 -> 2 (grass)
    const entry = i === 1 ? 2n : 1n;
    longs[Math.floor(i / 16)] |= entry << BigInt((i % 16) * 4);
  }
  // 26.x: plain ids wrapped as {"": id} once any entry has properties
  const palette: W = legacy
    ? ["list", [
        ["compound", { Name: ["string", "minecraft:air"] }],
        ["compound", { Name: ["string", "minecraft:stone"] }],
        ["compound", { Name: ["string", "minecraft:grass_block"], Properties: ["compound", { snowy: ["string", "false"] }] }],
      ]]
    : ["list", [
        ["compound", { "": ["string", "minecraft:air"] }],
        ["compound", { "": ["string", "minecraft:stone"] }],
        ["compound", { id: ["string", "minecraft:grass_block"], properties: ["compound", { snowy: ["string", "false"] }] }],
      ]];
  const sections: W[] = [
    ["compound", { Y: ["byte", 4], block_states: ["compound", { palette, data: ["longs", longs] }] }],
  ];
  // A single-entry section saved as a list of strings (26.x) or {Name} (older)
  if (!legacy) sections.push(["compound", { Y: ["byte", 3], block_states: ["compound", { palette: ["list", [["string", "minecraft:dirt"]]] }] }]);
  const root: W = ["compound", { DataVersion: ["int", 4000], Status: ["string", status], sections: ["list", sections] }];
  return Buffer.concat([Buffer.from([10]), payload(["string", ""]), payload(root)]);
}

// Region r.0.0 with chunk 0,0 stored inside, chunk 1,0 stored outside in a
// .mcc file, and chunk 2,0 still being generated
function writeWorld(legacy: boolean) {
  const dir = mkdtempSync(join(tmpdir(), "world-"));
  const regionDir = legacy ? join(dir, "region") : join(dir, "dimensions", "minecraft", "overworld", "region");
  mkdirSync(regionDir, { recursive: true });
  const header = Buffer.alloc(8192);
  const sectors: Buffer[] = [];
  const store = (cx: number, data: Buffer, external: boolean) => {
    const body = deflateSync(data);
    const head = Buffer.alloc(5);
    head.writeInt32BE(external ? 1 : body.length + 1);
    head[4] = external ? 2 | 128 : 2;
    if (external) writeFileSync(join(regionDir, `c.${cx}.0.mcc`), body);
    const sector = Buffer.concat([head, external ? Buffer.alloc(0) : body]);
    const padded = Buffer.alloc(Math.ceil(sector.length / 4096) * 4096);
    sector.copy(padded);
    header.writeUIntBE(2 + sectors.reduce((n, b) => n + b.length / 4096, 0), 4 * cx, 3);
    header[4 * cx + 3] = padded.length / 4096;
    sectors.push(padded);
  };
  store(0, chunk(legacy), false);
  store(1, chunk(legacy), true);
  store(2, chunk(legacy, "minecraft:features"), false);
  writeFileSync(join(regionDir, "r.0.0.mca"), Buffer.concat([header, ...sectors]));
  return dir;
}
const dir = writeWorld(false);
const legacyDir = writeWorld(true);
afterAll(() => (rmSync(dir, { recursive: true }), rmSync(legacyDir, { recursive: true })));

test("reads blocks from a region file", () => {
  const world = new World(dir);
  expect(world.block(0, 64, 0)).toBe("minecraft:stone");
  expect(world.block(1, 64, 0)).toBe("minecraft:grass_block");
  expect(world.block(5, 65, 5)).toBe("minecraft:air");
  expect(world.block(5, 63, 5)).toBe("minecraft:dirt"); // single-entry section
  expect(world.block(5, 10, 5)).toBe("minecraft:air"); // no section saved there
  expect(world.block(100, 64, 0)).toBeNull(); // chunk never saved
});

test("reads chunks stored outside the region file", () => {
  expect(new World(dir).block(16, 64, 0)).toBe("minecraft:stone");
});

test("treats chunks still being generated as unreadable", () => {
  expect(new World(dir).block(32, 64, 0)).toBeNull();
});

test("refuses a world folder with no region files", () => {
  expect(() => new World(join(dir, "nope"))).toThrow("no region files");
});

test("scan counts blocks and maps the top layer", () => {
  const out = scan(new World(dir), { x1: 0, y1: 63, z1: 0, x2: 2, y2: 65, z2: 1 });
  expect(out.counts).toEqual({ "minecraft:air": 6, "minecraft:dirt": 6, "minecraft:stone": 5, "minecraft:grass_block": 1 });
  expect(out.top_view.rows).toEqual(["aba", "aaa"]);
  expect(out.top_view.key).toEqual({ a: "minecraft:stone", b: "minecraft:grass_block" });
});

test("reads worlds saved before 26.x", () => {
  const world = new World(legacyDir);
  expect(world.block(0, 64, 0)).toBe("minecraft:stone");
  expect(world.block(1, 64, 0)).toBe("minecraft:grass_block");
});

test("scan refuses huge boxes", () => {
  expect(() => scan(new World(dir), { x1: 0, y1: 0, z1: 0, x2: 100, y2: 100, z2: 100 })).toThrow("limit");
});

test("past the last letter, top blocks share ? and all stay in the key", () => {
  const world = new World(dir);
  // A fake world whose every column tops out in a different block
  (world as unknown as { block: (x: number, y: number, z: number) => string }).block = (x, y, z) =>
    y === 0 ? `minecraft:b${x + z * 10}` : "minecraft:air";
  const out = scan(world, { x1: 0, y1: 0, z1: 0, x2: 9, y2: 1, z2: 6 });
  expect(Object.keys(out.top_view.key)).toHaveLength(63);
  expect(out.top_view.key["?"]).toHaveLength(70 - 62);
});
