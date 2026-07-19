#!/usr/bin/env bash
set -euo pipefail

echo "Downloading Malaysia OSM data..."
mkdir -p valhalla_tiles
wget -O valhalla_tiles/malaysia.osm.pbf \
  "https://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf"

echo "Starting Valhalla tile build (this may take 10-30 minutes)..."
docker-compose up
