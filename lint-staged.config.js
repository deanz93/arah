export default {
  'apps/mobile/src/**/*.{ts,tsx}': [
    'bash -c "cd apps/mobile && npx eslint --fix"',
    'bash -c "cd apps/mobile && npx tsc --noEmit"',
  ],
  'apps/web/src/**/*.{ts,tsx}': [
    'bash -c "cd apps/web && npx eslint --fix"',
  ],
  'services/api-gateway/src/**/*.ts': [
    'bash -c "cd services/api-gateway && npx eslint --fix"',
  ],
  '**/*.{ts,tsx,js,json,md,yml,yaml}': [
    'prettier --write --ignore-unknown',
  ],
}
