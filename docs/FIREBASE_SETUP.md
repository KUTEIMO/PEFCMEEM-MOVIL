# Firebase y hosting web — PEFCMEEM (*Domina las matemáticas.*)

Esta guía conecta el proyecto Flutter con **Firebase Authentication**, **Cloud Firestore** (grupos + ranking) y **Firebase Hosting** (build web). El borrador académico del proyecto está en **`docs/DOCUMENTO_PROYECTO_PEFCMEEM.md`** (y en la app: *Ajustes → Sobre*). No pegues **claves de cuenta de servicio** en chats ni las subas al repositorio público.

## 1. Crear proyecto en Firebase Console

1. Entra a [Firebase Console](https://console.firebase.google.com/) y crea un proyecto.
2. Añade una app **Android** con el package `com.pefcmeem.app.pefcmeem`.
3. Añade una app **Web** (nombre libre).
4. (Opcional) Añade app **iOS** con bundle `com.pefcmeem.app.pefcmeem`.

Descarga los archivos nativos y **sustituye** los placeholders del repo:

| Plataforma | Archivo en el repo |
|------------|---------------------|
| Android | `android/app/google-services.json` |
| iOS | `ios/Runner/GoogleService-Info.plist` |

**Gradle Android:** el plugin `com.google.gms.google-services` (4.4.4) ya está declarado en `android/settings.gradle.kts` (`apply false`) y aplicado en `android/app/build.gradle.kts`. Si pegas `google-services.json` en la raíz del repo, cópialo también a `android/app/` (Gradle solo lee esa ruta).

## 2. FlutterFire CLI (genera `lib/firebase_options.dart`)

**Requisito:** FlutterFire invoca el **Firebase CLI** (`firebase --version`). Instálalo con `npm install -g firebase-tools` e inicia sesión con `firebase login`. En Windows, si el comando no se reconoce, añade al **PATH** la carpeta que devuelve `npm config get prefix` (suele ser `%AppData%\Roaming\npm`).

En la raíz del proyecto:

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --project=pefcmeem-633d9 --yes --platforms=android,web,ios --overwrite-firebase-options
```

(O usa `dart pub global run flutterfire_cli:flutterfire configure` si `flutterfire` no está en el PATH.)

Esto alinea **`lib/firebase_options.dart`** con el mismo `project_id` que `android/app/google-services.json` y puede registrar la app **iOS** en Firebase si aún no existía. Si `ios/Runner/GoogleService-Info.plist` no se reescribe, genera uno válido con (sustituye el App ID iOS por el de la consola o el de `firebase_options.dart`):

```bash
firebase apps:sdkconfig IOS TU_IOS_APP_ID --project pefcmeem-633d9
```

(`TU_IOS_APP_ID` es el valor `GOOGLE_APP_ID` / `appId` de iOS en la consola o en `lib/firebase_options.dart`.) Copia el XML a `ios/Runner/GoogleService-Info.plist` y, si hace falta, corrige booleanos a `<true/>` / `<false/>`.

Las API keys de cliente no son “secretas” de backend; el uso real está acotado por reglas de Firestore y restricciones en la consola.

## 3. Activar servicios en la consola

- **Authentication** → método **Anónimo** → habilitar (opcional).
- **Authentication** → **Correo / contraseña** → habilitar (requerido en v2 de la app).
- **Firestore Database** → crear en modo **producción** (luego pega reglas abajo).

**Colecciones en consola:** Firestore no lista colecciones vacías; hace falta al menos un documento. Tras **iniciar sesión**, la app escribe `meta/bootstrap` para que veas la colección `meta`. `users/{uid}` aparece al registrarte. `groups` y la subcolección `members` aparecen al **crear un grupo** (con colegio) o **unirse con código**.

## 4. Reglas de Firestore (MVP)

En Firestore → Reglas → Editor. Ajusta según evolucione el producto:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /groups/{groupId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null
        && request.resource.data.keys().hasAll(['name','code','teacherUid','createdAt'])
        && request.resource.data.teacherUid == request.auth.uid
        && request.resource.data.name is string
        && request.resource.data.name.size() > 0
        && request.resource.data.name.size() < 80
        && request.resource.data.code is string
        && request.resource.data.code.size() == 6;

      allow update, delete: if request.auth != null
        && resource.data.teacherUid == request.auth.uid;

      match /members/{memberId} {
        allow read: if request.auth != null;
        allow create, update: if request.auth != null
          && memberId == request.auth.uid
          && request.resource.data.keys().hasAll(['displayName','totalXp','joinedAt','lastActiveAt'])
          && request.resource.data.displayName is string
          && request.resource.data.displayName.size() < 60;
      }
    }
  }
}
```

**Nota:** La fuente de verdad es el archivo `firestore.rules` del repositorio (incluye la colección `meta` y el fragmento anterior puede estar desactualizado). El modelo MVP permite que cualquier usuario autenticado cree un grupo; si quieres restringir “solo docentes”, añade un campo `role` en un doc `users/{uid}` y comprueba en `allow create`.

### Desplegar reglas e índices desde el repo

En la raíz del proyecto hay `firestore.rules`, `firestore.indexes.json`, `firebase.json` y `.firebaserc`. No hace falta instalar Firebase CLI de forma global:

```bash
npx --yes firebase-tools@latest login
npx --yes firebase-tools@latest deploy --only firestore
```

Eso crea o actualiza la base **(default)**, sube las reglas y los índices declarados en `firestore.indexes.json`.

**Windows:** si tras `npm install -g firebase-tools` el comando `firebase` no se reconoce, añade al **PATH** del usuario la carpeta que devuelve `npm config get prefix` (suele ser `%AppData%\Roaming\npm`). Mientras tanto puedes usar solo `npx --yes firebase-tools@latest ...` como arriba.

**Si Firestore sigue vacío tras usar la app:** no exijas en reglas `hasAll` sobre campos que solo envías con `FieldValue.serverTimestamp()` (en la evaluación a veces no están en `request.resource`). El `firestore.rules` del repo corrige eso para `meta/bootstrap` y creación de `groups`. Despliega reglas de nuevo y **reinstala** un APK generado después del cambio.

## 5. Índices

Las consultas actuales (`where` por un solo campo en `groups`, `orderBy('totalXp')` en la subcolección `members` de un grupo) usan **índices automáticos** de Firestore. En `firestore.indexes.json` solo deben ir índices **compuestos** o **collection group** que la consola o el error de la app indiquen como necesarios. Si al desplegar el CLI responde que un índice «no es necesario», quítalo del JSON (los de un solo campo suelen gestionarse solos).

Si en el futuro añades filtros combinados (p. ej. `where` + `orderBy` en campos distintos), Firestore mostrará un enlace para crear el índice compuesto; puedes copiarlo a `firestore.indexes.json` y volver a desplegar.

## 6. Probar en local

```bash
flutter pub get
flutter run
```

Si `FirebaseBootstrap.isReady` es falso, revisa `Ajustes` en la app o la consola de depuración: suele ser `firebase_options` o `google-services.json` desactualizados.

## 7. Build web y Firebase Hosting

**Importante:** `firebase deploy` solo sube lo que esté en **`build/web`**. Si cambias Dart, `web/index.html` o assets y solo ejecutas deploy, **se publicará una versión vieja**. Siempre compila antes:

El build de producción recomendado **no registra service worker** (`--pwa-strategy none`): evita cargas colgadas por actualizaciones del SW y acelera el primer arranque. Si más adelante quieres modo offline/PWA, quita ese flag.

```bash
flutter build web --release --pwa-strategy none --no-wasm-dry-run
```

En Windows puedes usar el script del repo (compila y despliega en un solo paso):

```powershell
pwsh -File scripts/deploy_web.ps1
```

### Caché del navegador y despliegues

Firebase Hosting usa cabeceras en `firebase.json` para que **`index.html`**, **`main.dart.js`**, **`flutter_service_worker.js`** y **`about.html`** no queden “pegados” en caché tras un deploy. Si aún ves una versión antigua, prueba recarga forzada (Ctrl+F5) o una ventana de incógnito.

Instala [Firebase CLI](https://firebase.google.com/docs/cli), inicia sesión y en la raíz del proyecto:

```bash
firebase login
firebase init hosting
```

- Directorio público: `build/web`
- SPA: **sí** (rewrites a `/index.html`)

Despliegue manual (equivalente al script, sin `--release` si prefieres debug):

```bash
flutter build web --release --pwa-strategy none --no-wasm-dry-run
firebase deploy --only hosting:pefcmeem-633d9-e5f18
```

Si publicas en una **subruta** (p.ej. GitHub Pages con proyecto de usuario), usa:

```bash
flutter build web --base-href="/nombre-repo/"
```

## 8. Seguridad

- No compartas **JSON de cuenta de servicio** en chats; úsalo solo en tu máquina o en CI con **secretos** del proveedor.
- Las reglas de Firestore son obligatorias antes de tráfico real.
- La sesión **anónima** se pierde si el usuario borra datos del sitio; para producción considera enlace con Google/Apple.

## 9. Android `minSdk`

Si Gradle avisa por versiones, mantén `minSdk` al valor que exija el BoM de Firebase (suele ser ≥ 21). El proyecto usa el valor por defecto de Flutter salvo que lo subas en `android/app/build.gradle.kts`.
