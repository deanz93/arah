# GitHub Actions — Required Secrets

Go to **GitHub → Settings → Secrets and variables → Actions → New repository secret** to add these.

## CI Secrets (required for CI to pass)

| Secret | Description |
|--------|-------------|
| *(none required for CI)* | CI uses placeholder values for Firebase |

## Release Secrets (required for Android builds + web deploy)

### Firebase / Mobile
| Secret | Where to get |
|--------|-------------|
| `GOOGLE_SERVICES_JSON` | Firebase Console → Project Settings → Android app → `google-services.json` (paste entire file content) |
| `ARAH_API_URL` | Your deployed API Gateway URL (e.g. `https://api.arah.my`) |
| `ARAH_TILE_URL` | Your tile server URL |
| `ARAH_SOCKET_URL` | Your realtime service WebSocket URL |
| `VALHALLA_URL` | Your Valhalla routing URL |
| `NOMINATIM_URL` | Your Nominatim geocoding URL |

### Android Signing
| Secret | How to create |
|--------|--------------|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w 0 your-keystore.jks` |
| `ANDROID_KEY_ALIAS` | Alias used when creating the keystore |
| `ANDROID_STORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_PASSWORD` | Key password |

**Generate a keystore (one-time):**
```bash
keytool -genkeypair -v \
  -keystore arah-release.jks \
  -alias arah \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -dname "CN=Arah, OU=Mobile, O=Arah Malaysia, L=KL, S=WP, C=MY"
```

### Vercel (web deploy)
| Secret | Where to get |
|--------|-------------|
| `VERCEL_TOKEN` | vercel.com → Account Settings → Tokens |
| `VERCEL_ORG_ID` | `.vercel/project.json` after running `vercel link` |
| `VERCEL_PROJECT_ID` | `.vercel/project.json` after running `vercel link` |
