# Ejecución y despliegue — EULER (PEFCMEEM)

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) — `flutter doctor` sin errores críticos
- [Node.js](https://nodejs.org/) — para `npx firebase-tools`
- Cuenta Google y proyecto Firebase `pefcmeem-633d9`

## Desarrollo local

```bash
flutter pub get
flutter run
# Web: flutter run -d chrome
```

## Deploy web (Firebase Hosting)

**Windows (recomendado):**

```powershell
pwsh -File scripts/deploy_web.ps1
```

**Manual:**

```bash
flutter build web --release --pwa-strategy none --no-wasm-dry-run
npx -y firebase-tools@latest login
npx -y firebase-tools@latest deploy --only firestore:rules,hosting:pefcmeem-633d9-e5f18
```

URL típica: https://pefcmeem-633d9-e5f18.web.app

## APK Android

```bash
flutter build apk --release
```

Salida: `build/app/outputs/flutter-apk/app-release.apk`  
Copia publicada en `releases/app-release.apk` y en [GitHub Releases](https://github.com/KUTEIMO/PEFCMEEM-MOVIL/releases) (`v2.0.0`).

## Git en otra PC

Ver [CONFIG-GIT-FOR-WORK.md](../CONFIG-GIT-FOR-WORK.md).

## Problemas frecuentes

| Problema | Solución |
|----------|----------|
| Firebase no inicializa | Revisar `lib/firebase_options.dart` y [FIREBASE_SETUP.md](FIREBASE_SETUP.md) |
| Wasm warning en build web | Informativo; el build release sigue siendo válido |
| APK no instala | Habilitar origen desconocido o usar `adb install` |
