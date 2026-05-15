# EULER (móvil + web)

App Flutter con Firebase (Auth, Firestore, Hosting). Repositorio: [PEFCMEEM-MOVIL](https://github.com/KUTEIMO/PEFCMEEM-MOVIL).

## Requisitos en cualquier PC

- [Flutter](https://docs.flutter.dev/get-started/install) (SDK estable, `flutter doctor` sin errores críticos)
- [Node.js](https://nodejs.org/) (para `npx` y despliegue de Hosting / reglas)
- Cuenta Google y proyecto Firebase configurado (ver `docs/FIREBASE_SETUP.md` si aplica)

## Clonar y preparar

```bash
git clone https://github.com/KUTEIMO/PEFCMEEM-MOVIL.git
cd PEFCMEEM-MOVIL
flutter pub get
```

Inicia sesión en Firebase cuando vayas a desplegar:

```bash
npx -y firebase-tools@latest login
```

## Correr en desarrollo (local)

```bash
flutter run
```

Elige dispositivo, emulador o Chrome según el modo que uses en el IDE o con `-d chrome`.

---

## Documentación para presentación

| Documento | Uso |
|-----------|-----|
| [docs/STORYTELLING_JURADO.md](docs/STORYTELLING_JURADO.md) | Guion oral para jurado (Cúcuta, ICFES, demo) |
| [docs/DOCUMENTACION_TECNICA_PEFCMEEM.md](docs/DOCUMENTACION_TECNICA_PEFCMEEM.md) | Arquitectura, Firebase, build, troubleshooting |
| [docs/DOCUMENTO_PROYECTO_PEFCMEEM.md](docs/DOCUMENTO_PROYECTO_PEFCMEEM.md) | Borrador académico completo |

## Web en producción (build + subir a Firebase Hosting)

**Recomendado (Windows):** compila, publica reglas de Firestore y sube Hosting en un paso:

```powershell
pwsh -File scripts/deploy_web.ps1
```

Manual:

1. **Compilar** la web en modo release:

```bash
flutter build web --release --pwa-strategy none --no-wasm-dry-run
```

2. **Publicar** hosting + reglas (sin instalar `firebase` global):

```bash
npx -y firebase-tools@latest deploy --only firestore:rules,hosting:pefcmeem-633d9-e5f18
```

Tras un despliegue correcto, el hosting queda en una URL del estilo:

`https://pefcmeem-633d9-e5f18.web.app`

(Consulta la URL exacta en la salida del comando o en [Firebase Console](https://console.firebase.google.com/) → Hosting.)

**Notas**

- Si aparece el aviso de Wasm, es informativo; el build sigue siendo válido. Opcional: [documentación Web/Wasm](https://docs.flutter.dev/platform-integration/web/wasm).
- El proyecto Firebase por defecto está definido en `.firebaserc` (`pefcmeem-633d9`).

---

## APK Android (release)

```bash
flutter build apk --release
```

El APK generado suele estar en:

`build/app/outputs/flutter-apk/app-release.apk`

(En algunas configuraciones puede verse como `build/app/outputs/apk/release/app-release.apk`; revisa la carpeta `build` si cambia la variante.)

Instálalo en el dispositivo copiando el archivo o con `adb install`.

---

## Más ayuda

- Configuración Git en otra máquina: `CONFIG-GIT-FOR-WORK.md`
- Firebase (opciones, plist, reglas): `docs/FIREBASE_SETUP.md`
