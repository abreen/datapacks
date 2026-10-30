// Turns JSON-like values into SNBT for /data and macro arguments

const BARE_KEY = /^[A-Za-z0-9_.+-]+$/;

export function quote(s: string): string {
  return '"' + s.replace(/\\/g, "\\\\").replace(/"/g, '\\"') + '"';
}

export function toSnbt(value: unknown): string {
  if (value === null || value === undefined) throw new Error("SNBT has no null");
  if (typeof value === "string") return quote(value);
  if (typeof value === "boolean") return value ? "1b" : "0b";
  if (typeof value === "number") {
    if (!Number.isFinite(value)) throw new Error(`SNBT can't hold ${value}`);
    // Whole numbers become ints, so they work as block coordinates in macros
    return Number.isInteger(value) ? String(value) : `${value}d`;
  }
  if (Array.isArray(value)) return "[" + value.map(toSnbt).join(",") + "]";
  if (typeof value === "object") {
    const entries = Object.entries(value as Record<string, unknown>).map(
      ([k, v]) => (BARE_KEY.test(k) ? k : quote(k)) + ":" + toSnbt(v),
    );
    return "{" + entries.join(",") + "}";
  }
  throw new Error(`SNBT can't hold a ${typeof value}`);
}
