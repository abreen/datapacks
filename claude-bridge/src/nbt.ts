// Reads uncompressed NBT. Longs come back as bigint, long arrays as
// BigInt64Array.

export type Nbt = number | bigint | string | Nbt[] | Int8Array | Int32Array | BigInt64Array | { [key: string]: Nbt };

export function readNbt(buf: Buffer): Nbt {
  const r = new Reader(buf);
  const type = r.byte();
  r.string(); // root name
  return r.payload(type);
}

class Reader {
  private pos = 0;
  constructor(private buf: Buffer) {}

  byte() {
    return this.buf.readInt8(this.pos++);
  }
  private short() {
    const v = this.buf.readInt16BE(this.pos);
    this.pos += 2;
    return v;
  }
  private int() {
    const v = this.buf.readInt32BE(this.pos);
    this.pos += 4;
    return v;
  }
  private long() {
    const v = this.buf.readBigInt64BE(this.pos);
    this.pos += 8;
    return v;
  }
  string() {
    const length = this.buf.readUInt16BE(this.pos);
    this.pos += 2;
    // Java's modified UTF-8 matches UTF-8 for everything but NUL and
    // characters outside the BMP, which block and entity ids never use
    const s = this.buf.toString("utf8", this.pos, this.pos + length);
    this.pos += length;
    return s;
  }

  payload(type: number): Nbt {
    switch (type) {
      case 1: return this.byte();
      case 2: return this.short();
      case 3: return this.int();
      case 4: return this.long();
      case 5: {
        const v = this.buf.readFloatBE(this.pos);
        this.pos += 4;
        return v;
      }
      case 6: {
        const v = this.buf.readDoubleBE(this.pos);
        this.pos += 8;
        return v;
      }
      case 7: {
        const n = this.int();
        const v = new Int8Array(this.buf.subarray(this.pos, this.pos + n));
        this.pos += n;
        return v;
      }
      case 8: return this.string();
      case 9: {
        const itemType = this.byte();
        const n = this.int();
        const list: Nbt[] = [];
        for (let i = 0; i < n; i++) list.push(this.payload(itemType));
        return list;
      }
      case 10: {
        const out: { [key: string]: Nbt } = {};
        for (;;) {
          const t = this.byte();
          if (t === 0) return out;
          out[this.string()] = this.payload(t);
        }
      }
      case 11: {
        const n = this.int();
        const v = new Int32Array(n);
        for (let i = 0; i < n; i++) v[i] = this.int();
        return v;
      }
      case 12: {
        const n = this.int();
        const v = new BigInt64Array(n);
        for (let i = 0; i < n; i++) v[i] = this.long();
        return v;
      }
      default:
        throw new Error(`unknown NBT tag type ${type}`);
    }
  }
}
