# EULER (PEFCMEEM) — Móvil + Web

App **Flutter** con **Firebase** (Auth, Firestore, Hosting) para aprendizaje de matemáticas en educación media (grados 9–11): rutas, lecciones, gamificación, grupos y panel docente.

**Repositorio:** https://github.com/KUTEIMO/PEFCMEEM-MOVIL  
**Web (Firebase Hosting):** https://pefcmeem-633d9-e5f18.web.app  
**Proyecto Firebase:** `pefcmeem-633d9` (ver `.firebaserc`)

---

## Qué incluye

| Área | Descripción |
|------|-------------|
| **Estudiante** | Ruta de aprendizaje, ejercicios, ranking, perfil, grupos |
| **Docente** | Dashboard, grupos, seguimiento |
| **Web** | Landing y app en navegador (`flutter build web`) |
| **Android** | APK en `releases/` y [GitHub Releases](https://github.com/KUTEIMO/PEFCMEEM-MOVIL/releases) |

Compañero de aprendizaje **Euler** (UI), splash y branding propios (v2.0.0).

---

## Inicio rápido

```bash
git clone https://github.com/KUTEIMO/PEFCMEEM-MOVIL.git
cd PEFCMEEM-MOVIL
cp lib/firebase_options.example.dart lib/firebase_options.dart
flutterfire configure --project=pefcmeem-633d9
flutter pub get
flutter run
```

Deploy web y APK: [docs/EJECUCION-Y-DEPLOY.md](docs/EJECUCION-Y-DEPLOY.md).

---

## Documentación

| Documento | Contenido |
|-----------|-----------|
| [docs/EJECUCION-Y-DEPLOY.md](docs/EJECUCION-Y-DEPLOY.md) | Desarrollo, build web/APK, Firebase deploy |
| [docs/DOCUMENTACION_TECNICA_PEFCMEEM.md](docs/DOCUMENTACION_TECNICA_PEFCMEEM.md) | Arquitectura, Firebase, troubleshooting |
| [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) | Configuración Firebase |
| [docs/CATALOG_FIRESTORE.md](docs/CATALOG_FIRESTORE.md) | Colecciones Firestore |
| [docs/STORYTELLING_JURADO.md](docs/STORYTELLING_JURADO.md) | Guion para presentación / jurado |
| [docs/DOCUMENTO_PROYECTO_PEFCMEEM.md](docs/DOCUMENTO_PROYECTO_PEFCMEEM.md) | Documento académico del proyecto |
| [CONFIG-GIT-FOR-WORK.md](CONFIG-GIT-FOR-WORK.md) | Git en otra máquina |

---

## Estructura (resumen)

```text
lib/           # Flutter (features, core, theme, router)
web/           # HTML base PWA
scripts/       # deploy_web.ps1, export_logo_png.ps1
releases/      # APK publicado (app-release.apk)
docs/          # Documentación
firebase.json  # Hosting + reglas
```

---

## Licencia

[MIT](LICENSE) — Eduardo José Soto Herrera / KUTEIMO.
