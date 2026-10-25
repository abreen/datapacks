#!/usr/bin/env python3
"""Send commands to a Minecraft server over RCON and print the responses.

Usage:
    tools/rcon.py 'gamerule keep_inventory' 'datapack list enabled'
    tools/rcon.py < commands.txt

Commands come from the arguments, or from stdin one per line (blank lines
and lines starting with # are skipped). Connection settings come from the
environment: RCON_HOST (default 127.0.0.1), RCON_PORT (default 25575) and
RCON_PASSWORD.
"""
import os
import socket
import struct
import sys

LOGIN, COMMAND = 3, 2
# The server answers a request of an unknown type with "Unknown request",
# after any earlier response, so one is sent after each command to mark where
# a multi-packet response ends
SENTINEL_TYPE, SENTINEL_ID = 0, 0x7FFF


def send(sock, request_id, kind, body):
    payload = body.encode() + b"\x00\x00"
    sock.sendall(struct.pack("<iii", len(payload) + 8, request_id, kind) + payload)


def read_exactly(sock, n):
    data = b""
    while len(data) < n:
        chunk = sock.recv(n - len(data))
        if not chunk:
            raise ConnectionError("server closed the connection")
        data += chunk
    return data


def receive(sock):
    (length,) = struct.unpack("<i", read_exactly(sock, 4))
    data = read_exactly(sock, length)
    request_id, _kind = struct.unpack("<ii", data[:8])
    return request_id, data[8:-2].decode()


def run(sock, command, request_id):
    send(sock, request_id, COMMAND, command)
    # The server closes the connection if a second packet reaches it before it
    # has handled the first, so the sentinel waits until a reply has arrived
    _, body = receive(sock)
    parts = [body]
    send(sock, SENTINEL_ID, SENTINEL_TYPE, "")
    while True:
        response_id, body = receive(sock)
        if response_id == SENTINEL_ID:
            return "".join(parts)
        parts.append(body)


def main():
    host = os.environ.get("RCON_HOST", "127.0.0.1")
    port = int(os.environ.get("RCON_PORT", "25575"))
    password = os.environ.get("RCON_PASSWORD", "")

    if len(sys.argv) > 1:
        commands = sys.argv[1:]
    else:
        commands = [line.strip() for line in sys.stdin]
        commands = [c for c in commands if c and not c.startswith("#")]

    with socket.create_connection((host, port)) as sock:
        send(sock, 1, LOGIN, password)
        if receive(sock)[0] == -1:
            sys.exit("rcon: wrong password")
        for i, command in enumerate(commands, start=2):
            print(f"> {command}\n  {run(sock, command, i)}")


if __name__ == "__main__":
    main()
