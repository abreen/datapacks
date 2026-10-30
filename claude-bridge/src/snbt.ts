// Turns JSON-like values into SNBT for /data and macro arguments

const BARE_KEY = /^[A-Za-z0-9_.+-]+$/;
const INT_MIN = -(2 ** 31);
const INT_MAX = 2 ** 31 - 1;

export function quote(s: string): string {
  return '"' + s.replace(/\\/g, "\\\\").replace(/"/g, '\\"') + '"';
}

export function toSnbt(value: unknown): string {
  if (value === null || value === undefined) throw new Error("SNBT has no null");
  if (typeof value === "string") return quote(value);
  if (typeof value === "boolean") return value ? "1b" : "0b";
  if (typeof value === "number") return number(value);
  if (Array.isArray(value)) return "[" + value.map(toSnbt).join(",") + "]";
  if (typeof value === "object") {
    const entries = Object.entries(value as Record<string, unknown>).map(
      ([k, v]) => (BARE_KEY.test(k) ? k : quote(k)) + ":" + toSnbt(v),
    );
    return "{" + entries.join(",") + "}";
  }
  throw new Error(`SNBT can't hold a ${typeof value}`);
}

function number(n: number): string {
  if (!Number.isFinite(n)) throw new Error(`SNBT can't hold ${n}`);
  if (!Number.isInteger(n)) return `${n}d`;
  // Whole numbers become ints, so they work as block coordinates in macros
  if (n >= INT_MIN && n <= INT_MAX) return String(n);
  if (Number.isSafeInteger(n)) return `${n}L`;
  throw new Error(`${n} is too big to pass exactly`);
}
