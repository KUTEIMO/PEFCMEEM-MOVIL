# Publica Hosting con el mismo build que verás en producción.
# Uso (desde la raíz del repo):  pwsh -File scripts/deploy_web.ps1
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

Write-Host ">> flutter build web --release --pwa-strategy none --no-wasm-dry-run" -ForegroundColor Cyan
flutter build web --release --pwa-strategy none --no-wasm-dry-run
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ">> firebase deploy firestore rules + hosting" -ForegroundColor Cyan
npx -y firebase-tools@latest deploy --only firestore:rules,hosting:pefcmeem-633d9-e5f18
exit $LASTEXITCODE
