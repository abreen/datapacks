#!/bin/sh
# Runs a throwaway Minecraft server with this repo's data packs for testing.
#
# Usage:
#   tools/test-server.sh start [--download] [--accept-eula] [pack ...]
#   tools/test-server.sh sync                 copy the packs again and /reload
#   tools/test-server.sh rcon 'command' ...   same arguments as tools/rcon.py
#   tools/test-server.sh setup <player>       clear and refill their inventory
#   tools/test-server.sh status
#   tools/test-server.sh stop
#
# start makes a fresh flat world with every pack (or only the ones named).
# The server.jar is cached in .cache/; downloading it needs --download, and
# the first start needs --accept-eula (Mojang's EULA), which is remembered.
# Each player who joins first gets every pack's test/setup.mcfunction run
# as them (test items, levels), through a generated test-setup pack. Each
# pack's test/world.mcfunction runs once after start, at the world spawn
# (test builds). Every other test/<name>.mcfunction is available as
# /function test_setup:<namespace>/<name>.
#
# Environment: MC_VERSION (default 26.3), TEST_SERVER_DIR (default
# $TMPDIR/datapacks-test-server), SERVER_PORT (25599), RCON_PORT (25598),
# RCON_PASSWORD (localtest), PACK_FORMAT (121, for the setup pack).
set -e
cd "$(dirname "$0")/.."
REPO=$(pwd)

MC_VERSION=${MC_VERSION:-26.3}
PACK_FORMAT=${PACK_FORMAT:-121}
DIR=${TEST_SERVER_DIR:-${TMPDIR:-/tmp}/datapacks-test-server}
DIR=${DIR%/}
SERVER_PORT=${SERVER_PORT:-25599}
export RCON_PORT=${RCON_PORT:-25598}
export RCON_PASSWORD=${RCON_PASSWORD:-localtest}
CACHE=$REPO/.cache
JAR=$CACHE/server-$MC_VERSION.jar
# Written into DIR so start never deletes a folder it didn't make
MARKER=.datapacks-test-server

# Log lines that every fresh 26.3 flat world prints and that aren't problems:
# the codename warning comes from the macOS version, and the flat world's
# empty generator-settings logs "No key layers" before falling back to defaults
NOISE='Unable to parse version .* to a codename|No key layers in MapLike'

die() { echo "test-server: $*" >&2; exit 1; }

running() {
  [ -f "$DIR/server.pid" ] && kill -0 "$(cat "$DIR/server.pid")" 2>/dev/null
}

# Prints the log's ERROR and WARN lines after line $1, minus known noise,
# each with the first line of its exception (where a parse error's message is)
problems() {
  tail -n +"$(($1 + 1))" "$DIR/server.log" | grep -Ev "$NOISE" | awk '
    /^\[/ { show = ($0 ~ /\/(ERROR|WARN)\]/); first = 1; if (show) print; next }
    show && first && !/^\tat / { print "  " $0; first = 0 }'
}

download() {
  mkdir -p "$CACHE"
  info=$(curl -fsS https://piston-meta.mojang.com/mc/game/version_manifest_v2.json |
    python3 -I -c '
import json, sys, urllib.request
v = sys.argv[1]
urls = [x["url"] for x in json.load(sys.stdin)["versions"] if x["id"] == v]
if not urls:
    sys.exit("no version " + v + " in the manifest")
s = json.load(urllib.request.urlopen(urls[0]))["downloads"]["server"]
print(s["url"], s["sha1"], s["size"])
' "$MC_VERSION")
  set -- $info
  echo "Downloading server.jar $MC_VERSION ($3 bytes)"
  curl -fsS -o "$JAR.part" "$1"
  [ "$(shasum -a 1 "$JAR.part" | cut -d' ' -f1)" = "$2" ] || { rm -f "$JAR.part"; die "SHA-1 mismatch"; }
  mv "$JAR.part" "$JAR"
}

copy_packs() {
  rm -rf "$DIR/world/datapacks"
  mkdir -p "$DIR/world/datapacks"
  # Symlinked packs are rejected by the server, so copy
  for pack in $(cat "$DIR/packs"); do
    cp -R "$REPO/$pack" "$DIR/world/datapacks/"
  done
  make_setup_pack
}

# Generates a pack with every pack's test/*.mcfunction: setup runs as each
# player the first time they join (and on `setup`), world runs once after
# start. It's never shipped: build.sh only zips data/.
make_setup_pack() {
  out=$DIR/world/datapacks/test-setup
  mkdir -p "$out/data/test_setup/function" "$out/data/minecraft/tags/function"
  printf '{"pack":{"description":"Test server setup","min_format":%s,"max_format":%s}}\n' \
    "$PACK_FORMAT" "$PACK_FORMAT" > "$out/pack.mcmeta"
  echo '{"values":["test_setup:tick"]}' > "$out/data/minecraft/tags/function/tick.json"
  echo 'execute as @a[tag=!test_setup.done] run function test_setup:join' \
    > "$out/data/test_setup/function/tick.mcfunction"
  join=$out/data/test_setup/function/join.mcfunction
  world=$out/data/test_setup/function/world.mcfunction
  printf 'tag @s add test_setup.done\nclear @s\n' > "$join"
  : > "$world"
  names=
  for pack in $(cat "$DIR/packs"); do
    ns=$(echo "$pack" | tr - _)
    for f in "$REPO/$pack"/test/*.mcfunction; do
      [ -f "$f" ] || continue
      mkdir -p "$out/data/test_setup/function/$ns"
      cp "$f" "$out/data/test_setup/function/$ns/"
    done
    [ -f "$REPO/$pack/test/world.mcfunction" ] && echo "function test_setup:$ns/world" >> "$world"
    [ -f "$REPO/$pack/test/setup.mcfunction" ] || continue
    echo "function test_setup:$ns/setup" >> "$join"
    names="$names${names:+, }$pack"
  done
  echo "tellraw @s {text:\"Test setup done: ${names:-no packs have one}\",color:\"gray\",italic:true}" >> "$join"
}

start() {
  download_ok=; eula_ok=
  while [ $# -gt 0 ]; do
    case $1 in
      --download) download_ok=1 ;;
      --accept-eula) eula_ok=1 ;;
      -*) die "unknown option $1" ;;
      *) break ;;
    esac
    shift
  done
  if [ $# -eq 0 ]; then
    set -- $(for m in */pack.mcmeta; do dirname "$m"; done)
  fi
  for pack; do
    [ -f "$pack/pack.mcmeta" ] || die "$pack is not a data pack"
  done

  running && die "already running in $DIR (stop it first)"
  if [ ! -f "$JAR" ]; then
    [ -n "$download_ok" ] || die "server.jar $MC_VERSION isn't cached; rerun with --download to fetch it from Mojang"
    download
  fi
  if [ -n "$eula_ok" ]; then
    mkdir -p "$CACHE" && touch "$CACHE/eula-accepted"
  fi
  [ -f "$CACHE/eula-accepted" ] || die "rerun with --accept-eula to accept Mojang's EULA (https://aka.ms/MinecraftEULA)"

  if [ -e "$DIR" ]; then
    [ -f "$DIR/$MARKER" ] || die "$DIR exists and wasn't made by this script"
    rm -rf "$DIR"
  fi
  mkdir -p "$DIR"
  touch "$DIR/$MARKER"
  echo "$*" > "$DIR/packs"
  echo eula=true > "$DIR/eula.txt"
  # pause-when-empty-seconds=0: an empty server stops ticking after 60 s, so
  # load and tick would never run. 26.x whitelists by default; turn it off
  # so a player can join without being added.
  cat > "$DIR/server.properties" <<EOF
level-type=minecraft\:flat
server-ip=127.0.0.1
server-port=$SERVER_PORT
query.port=$((SERVER_PORT + 1))
enable-rcon=true
rcon.port=$RCON_PORT
rcon.password=$RCON_PASSWORD
online-mode=true
white-list=false
pause-when-empty-seconds=0
EOF
  copy_packs

  (
    cd "$DIR"
    nohup java -Xmx2G -jar "$JAR" nogui > server.log 2>&1 < /dev/null &
    echo $! > server.pid
  )
  i=0
  until grep -q 'RCON running on' "$DIR/server.log" 2>/dev/null; do
    running || { tail -n 20 "$DIR/server.log"; die "server exited during startup"; }
    i=$((i + 1))
    [ $i -le 240 ] || die "server didn't start within 2 minutes; see $DIR/server.log"
    sleep 0.5
  done
  # RCON commands run at the world spawn. The chunk must be loaded before
  # the world setups build there, so force-load it in a separate command.
  tools/rcon.py 'forceload add ~ ~' 'function test_setup:world' > /dev/null
  echo "Started Minecraft $MC_VERSION in $DIR with: $*"
  echo "Join at localhost:$SERVER_PORT; RCON on port $RCON_PORT"
  out=$(problems 0)
  [ -z "$out" ] && echo "No errors or warnings in server.log" || { echo "Errors and warnings in server.log:"; echo "$out"; }
}

sync() {
  running || die "not running"
  copy_packs
  before=$(wc -l < "$DIR/server.log")
  # The second command is answered only after the reload has finished
  tools/rcon.py reload 'datapack list enabled'
  out=$(problems "$before")
  [ -z "$out" ] && echo "No errors or warnings after reload" || { echo "Errors and warnings after reload:"; echo "$out"; }
}

stop() {
  running || { echo "Not running"; return; }
  pid=$(cat "$DIR/server.pid")
  tools/rcon.py stop
  i=0
  while kill -0 "$pid" 2>/dev/null; do
    i=$((i + 1))
    [ $i -le 120 ] || die "server didn't stop within 60 s (pid $pid)"
    sleep 0.5
  done
  rm -f "$DIR/server.pid"
  echo "Stopped"
}

cmd=${1:-}
[ $# -gt 0 ] && shift
case $cmd in
  start) start "$@" ;;
  sync) sync ;;
  stop) stop ;;
  rcon) running || die "not running"; tools/rcon.py "$@" ;;
  setup)
    running || die "not running"
    [ $# -eq 1 ] || die "usage: setup <player>"
    tools/rcon.py "execute as $1 run function test_setup:join" ;;
  status)
    if running; then
      echo "Running in $DIR with: $(cat "$DIR/packs")"
      echo "Join at localhost:$SERVER_PORT; RCON on port $RCON_PORT"
    else
      echo "Not running"
    fi ;;
  *) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac
