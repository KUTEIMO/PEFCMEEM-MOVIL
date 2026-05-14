# Catálogo de cursos en Firestore (`published/courses`)

La app carga primero el documento público **`published` / `courses`**. Si existe y el campo **`courses`** es un array no vacío con la misma forma que en `assets/courses.json`, ese catálogo sustituye al local.

Si el documento no existe o hay error de red, se usa **`assets/courses.json`** como respaldo.

## Pasos rápidos (Firebase Console)

1. Ve a **Firestore Database** → **Iniciar colección** (si no existe) → ID de colección: `published`.
2. ID del documento: `courses`.
3. Añade un campo **`courses`** de tipo **array** y pega el contenido del array `"courses"` de tu `assets/courses.json` (o una versión ampliada con más ejercicios).
4. Despliega reglas: `firebase deploy --only firestore:rules` (debe incluir la regla de lectura pública de `published`).

En la app: **Ajustes → Actualizar catálogo remoto** para vaciar la caché y volver a leer.

## Formato

La raíz del JSON en assets es:

```json
{ "courses": [ /* ... */ ] }
```

En Firestore, el documento debe tener el campo **`courses`** con ese array (no hace falta envolver otra vez en `"courses"` dentro de un string).

## Notas

- Tamaño máximo por documento ~1 MiB; si el banco crece mucho, divide por cursos en varios documentos (requeriría un cambio de código).
- La escritura del documento debe hacerse desde consola o Admin SDK; las reglas actuales **no** permiten escritura cliente en `published`.
