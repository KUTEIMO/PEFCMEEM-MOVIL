# Convierte logos SVG a PNG listos para imprenta (300 dpi aprox. en tamano stand).
# Uso: pwsh -File scripts/export_logo_png.ps1
$ErrorActionPreference = "Stop"
$root = Join-Path $PSScriptRoot ".."
$branding = Join-Path $root "assets\branding"
$outDir = Join-Path $branding "print"

if (-not (Test-Path $outDir)) {
  New-Item -ItemType Directory -Path $outDir | Out-Null
}

$exports = @(
  @{ Svg = "euler_logo_stand.svg";  Png = "euler_logo_stand_2000px.png";  Width = 2000 },
  @{ Svg = "euler_logo_lockup.svg"; Png = "euler_logo_lockup_2760px.png"; Width = 2760 }
)

Write-Host ">> Instalando resvg (una vez) y exportando PNG..." -ForegroundColor Cyan
foreach ($item in $exports) {
  $svgPath = Join-Path $branding $item.Svg
  $pngPath = Join-Path $outDir $item.Png
  if (-not (Test-Path $svgPath)) {
    Write-Error "No existe: $svgPath"
  }
  npx -y @resvg/resvg-js-cli --fit-width $item.Width $svgPath $pngPath
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  Write-Host "OK $($item.Png)" -ForegroundColor Green
}

Write-Host ""
Write-Host "PNG en: $outDir" -ForegroundColor Green
