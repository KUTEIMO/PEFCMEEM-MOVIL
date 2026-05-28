# Documentación técnica — EULER

**EULER** (*Plataforma Educativa para el Fortalecimiento de Competencias Matemáticas en Estudiantes de Educación Media*) · Eslogan: **Domina las matemáticas.**

| Autores | Programa | Lugar / fecha |
|---------|----------|----------------|
| Juan Sebastian Perez Galvis | Ingeniería de Sistemas | Cúcuta, Colombia |
| Eduardo José Soto Herrera | Ingeniería de Sistemas | Febrero 2026 |

---

## 1. Resumen ejecutivo técnico

Aplicación **Flutter** multiplataforma (Android + Web) con backend **Firebase** (Auth, Firestore, Hosting). Contenido pedagógico local en `assets/courses.json` con opción de catálogo remoto en `published/courses`. Grupos con código, ranking por XP y **chat** en subcolección `groups/{id}/messages`.

**URL web (Hosting):** https://pefcmeem-633d9-e5f18.web.app  
**APK release:** `build/app/outputs/flutter-apk/app-release.apk` (generar con `flutter build apk --release`).

---

## 2. Stack y versiones

| Capa | Tecnología |
|------|------------|
| Cliente | Flutter 3.x, Dart ^3.10 |
| Navegación | go_router 14 (shell estudiante `/s/*`, docente `/t/*`) |
| Estado | ChangeNotifier (`AppState`) + SharedPreferences |
| Auth | Firebase Auth (email/contraseña) |
| Datos en tiempo real | Cloud Firestore |
| Web estática | Firebase Hosting (`build/web`) |
| Tipografía | google_fonts (DM Sans, Sora) |
| Marca | SVG (`assets/branding/`) |

---

## 3. Arquitectura

```
main.dart → PefcmeemBootstrap (Firebase + AppState.init)
         → attachRouter(GoRouter) → PefcmeemApp

Rutas principales:
  /auth          EmailAuthScreen
  /onboarding    OnboardingScreen
  /about         AboutScreen (Markdown del proyecto)
  /s/*           StudentShell (móvil: bottom nav; web: rail/drawer)
  /t/*           TeacherShell
  /settings      Ajustes (tema, catálogo, Sobre, sesión)
  /join-group    Unirse con código (crea members/{uid})
  /group-chat/*  Chat del grupo
```

**Web vs móvil**

- **Web:** sin splash pesado de marca en Flutter; fondo `#0B3340` en `web/index.html`; shell con `NavigationRail` / `Drawer`; **sin** enlace HTML fijo que tape el engranaje de Ajustes; acciones **ℹ Sobre** + **⚙ Ajustes** en AppBar.
- **Móvil:** splash `AppSplashScreen`; barra inferior + Pibo flotante; splash nativo vía `flutter_native_splash`.

**Rendimiento**

- Catálogo: carga inmediata desde assets; Firestore en segundo plano.
- `GoRouter` único (no se recrea en cada `notifyListeners`).
- Build web: `--pwa-strategy none` para evitar cuelgues del service worker.

---

## 4. Firebase

### 4.1 Proyecto

- **Project ID:** `pefcmeem-633d9`
- **Hosting site:** `pefcmeem-633d9-e5f18`
- Config generada: `lib/firebase_options.dart`, `android/app/google-services.json`

### 4.2 Authentication

Habilitar en consola: **Email/Password**. La app no usa sesión anónima en producción (se cierra si detecta usuario anónimo).

Mensajes de error amigables: `lib/core/utils/auth_messages.dart`.

### 4.3 Firestore — colecciones

| Ruta | Uso |
|------|-----|
| `users/{uid}` | Perfil (rol, email, displayName, schoolName docente) |
| `groups/{id}` | Grupo (code, teacherUid, schoolName) |
| `groups/{id}/members/{uid}` | **Obligatorio para chat** (estudiante) |
| `groups/{id}/messages/*` | Chat |
| `published/courses` | Catálogo remoto (lectura pública) |
| `meta/bootstrap` | Metadatos de esquema |

Reglas: `firestore.rules` en la raíz del repo.

**Desplegar reglas (sin instalar Firebase CLI global):**

```powershell
npx -y firebase-tools@latest deploy --only firestore:rules
```

### 4.4 Chat — requisitos para demo

1. Usuario autenticado.
2. Estudiante: haberse unido al grupo (**Unirse con código** crea `members/{uid}`).
3. Docente: es `teacherUid` del grupo.
4. Reglas publicadas en Firebase.

---

## 5. Build y despliegue

### 5.1 Web (recomendado)

```powershell
pwsh -File scripts/deploy_web.ps1
```

Equivale a:

```bash
flutter build web --release --pwa-strategy none --no-wasm-dry-run
npx -y firebase-tools@latest deploy --only hosting:pefcmeem-633d9-e5f18
```

### 5.2 APK Android

```bash
flutter build apk --release
```

Salida: `build/app/outputs/flutter-apk/app-release.apk`

**Nota:** `flutter_native_splash` debe estar en `dependencies` (no solo `dev_dependencies`) para que compile el plugin en release.

### 5.3 Pruebas locales

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome   # web
flutter run             # dispositivo
```

---

## 6. Guía rápida para examinadores (demo)

1. Abrir **https://pefcmeem-633d9-e5f18.web.app** (recarga forzada si vieron versión antigua: Ctrl+F5).
2. **Registro** estudiante o docente (correo real o de prueba).
3. Estudiante: onboarding → **Unirse a grupo** con código del docente.
4. Completar una lección corta → XP y ranking.
5. **Chat del grupo** desde Ranking (icono chat) tras unirse.
6. **Sobre EULER:** icono ℹ en barra superior (web) o **Ajustes → Sobre** (móvil/web).

Documento académico completo: `docs/DOCUMENTO_PROYECTO_EULER.md` y `docs/STORYTELLING_JURADO.md`.

---

## 7. Solución de problemas

| Síntoma | Causa probable | Acción |
|---------|----------------|--------|
| Chat sin mensajes / PERMISSION_DENIED | Sin `members/{uid}` o reglas viejas | Re-unirse al grupo; `deploy --only firestore:rules` |
| Login falla | Email/Password off en Firebase | Authentication → Sign-in method |
| Web lenta primera vez | Descarga CanvasKit + JS | Normal; visitas siguientes más rápidas |
| Web muestra versión vieja | Caché | Ctrl+F5; verificar que se hizo `flutter build web` antes del deploy |
| APK no compila splash | Plugin solo en dev_dependencies | Mover `flutter_native_splash` a `dependencies` |
| `firebase` no reconocido en terminal | CLI no en PATH | Usar `npx -y firebase-tools@latest` |

---

## 8. Repositorio y documentación relacionada

| Archivo | Contenido |
|---------|-----------|
| `docs/DOCUMENTO_PROYECTO_EULER.md` | Borrador académico (ICFES, marco teórico, metodología) |
| `docs/STORYTELLING_JURADO.md` | Narrativa para jurado / defensa |
| `docs/FIREBASE_SETUP.md` | Configuración Firebase paso a paso |
| `docs/CATALOG_FIRESTORE.md` | Publicar cursos en Firestore |
| `CONFIG-GIT-FOR-WORK.md` | Clonar repo en otro equipo |

---

*Última actualización: preparación para presentación de fase — EULER.*
