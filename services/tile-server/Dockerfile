# Tile server wraps maptiler/tileserver-gl with pre-bundled config.
# PMTiles data is mounted at runtime from an EFS PVC — not baked into the image.
FROM node:24-alpine AS runtime

ENV NODE_ENV=production

# tileserver-gl-light is the headless (no Mapbox GL native) variant — works on Alpine
RUN npm install -g tileserver-gl-light

# Config and styles are part of the image; tile data is mounted externally
COPY config.json /config/config.json

WORKDIR /data
EXPOSE 8080

HEALTHCHECK --interval=20s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["tileserver-gl-light", "--config", "/config/config.json", "--port", "8080"]
