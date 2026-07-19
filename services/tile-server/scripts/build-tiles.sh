#!/usr/bin/env bash
set -euo pipefail

# Requires: Java 21+, planetiler JAR
PLANETILER_VERSION="0.8.3"
PLANETILER_JAR="planetiler-${PLANETILER_VERSION}-with-deps.jar"

mkdir -p data

if [ ! -f "${PLANETILER_JAR}" ]; then
  echo "Downloading Planetiler..."
  wget -O "${PLANETILER_JAR}" \
    "https://github.com/onthegomap/planetiler/releases/download/v${PLANETILER_VERSION}/planetiler-${PLANETILER_VERSION}-with-deps.jar"
fi

echo "Downloading Malaysia OSM data..."
wget -O data/malaysia.osm.pbf \
  "https://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf"

echo "Building PMTiles (this takes 5-15 minutes)..."
java -Xmx4g -jar "${PLANETILER_JAR}" \
  --osm-path=data/malaysia.osm.pbf \
  --output=data/malaysia.pmtiles \
  --bounds=99.5,1.0,119.5,7.5

echo "Tiles built at data/malaysia.pmtiles"
echo "Start tile server: docker-compose up"
