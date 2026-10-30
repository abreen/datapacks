import { expect, test } from "bun:test";
import { toSnbt } from "../src/snbt";

test("objects, numbers and booleans", () => {
  expect(toSnbt({ x: 1, y: -64, scale: 0.5, ok: true })).toBe("{x:1,y:-64,scale:0.5d,ok:1b}");
});

test("strings are quoted and escaped", () => {
  expect(toSnbt({ block: 'minecraft:oak_sign[rotation=4]{"a":"b\\c"}' })).toBe(
    '{block:"minecraft:oak_sign[rotation=4]{\\"a\\":\\"b\\\\c\\"}"}',
  );
});

test("keys that need quotes get them", () => {
  expect(toSnbt({ "a b": [1, "x"] })).toBe('{"a b":[1,"x"]}');
});

test("big whole numbers become longs, and too big ones are refused", () => {
  expect(toSnbt(2 ** 31)).toBe("2147483648L");
  expect(() => toSnbt(1e21)).toThrow("too big");
});
