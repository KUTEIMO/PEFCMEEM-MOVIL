# PEFCMEEM (móvil + web)

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

## Web en producción (build + subir a Firebase Hosting)

Desde la raíz del proyecto:

1. **Compilar** la web en modo release:

```bash
flutter build web --release
```

2. **Publicar** el contenido de `build/web` en el sitio de Hosting del proyecto (ajusta el ID de sitio si en `firebase.json` / consola usas otro):

```bash
npx -y firebase-tools@latest deploy --only hosting:pefcmeem-633d9-e5f18
```

3. **Reglas de Firestore** (cuando cambies `firestore.rules`):

```bash
npx -y firebase-tools@latest deploy --only firestore:rules
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
