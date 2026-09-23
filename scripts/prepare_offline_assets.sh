#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AS="$ROOT/app/src/main/assets"
BASE="https://cdn.jsdelivr.net/gh/mohammed-2-5/islamic-library-data@master"
QBASE="https://cdn.quran.ws/svg/pages/v1.1.1/hafs-kfqc"
mkdir -p "$AS/data/azkar" "$AS/data/hadith" "$AS/quran-pages" "$AS/adhan" "$ROOT/app/src/main/res/raw"

for f in azkar-sabah.json azkar-masaa.json sleep.json after_prayer.json ruqyah-shariah.json famous-doaa.json travel.json food.json mosque.json home.json wudu.json morning_evening.json; do
  curl -L --fail --retry 3 -sS "$BASE/azkar/$f" -o "$AS/data/azkar/$f"
done
curl -L --fail --retry 3 -sS "$BASE/hadith/bukhari.json" -o "$AS/data/hadith/bukhari.json"
curl -L --fail --retry 3 -sS "$BASE/hadith/muslim.json" -o "$AS/data/hadith/muslim.json"

for n in $(seq -w 1 604); do
  curl -L --fail --retry 3 -sS "$QBASE/$n.svg" -o "$AS/quran-pages/$n.svg"
done

# CC0 adhan recording, Wikimedia Commons: Beautiful_adhan.ogg by Adam-synagda.
curl -L --fail --retry 3 -sS "https://upload.wikimedia.org/wikipedia/commons/b/b0/Beautiful_adhan.ogg" -o "$ROOT/app/src/main/res/raw/adhan.ogg"
cp "$ROOT/app/src/main/res/raw/adhan.ogg" "$AS/adhan/beautiful_adhan.ogg"

cat > "$AS/OFFLINE_CONTENT.txt" <<EOF
YAWMY offline content bundle
- Quran: local 604-page Hafs/KFQC Madinah Mushaf SVGs
- Hadith: Sahih al-Bukhari and Sahih Muslim JSON datasets
- Azkar: local JSON datasets
- Stories/principles: bundled in index.html
- Adhan: Beautiful_adhan.ogg (CC0, Wikimedia Commons; author Adam-synagda)
No runtime network request is required for the app content.
EOF
