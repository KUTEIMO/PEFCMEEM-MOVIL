# Storytelling para el jurado — EULER

**Guion de 8–12 minutos** · Cúcuta, Educación Media, matemáticas e ICFES  
*Domina las matemáticas.*

---

## 1. Gancho (30 segundos)

> En Cúcuta, como en gran parte de Colombia, un estudiante de 11° puede tener el celular en el bolsillo todo el día… y aun así sentir que las matemáticas del Saber 11° están lejos. No es falta de ganas: es falta de **rutas cortas**, **feedback inmediato** y **acompañamiento** cuando más importa.

**EULER** es la respuesta que proponemos: una plataforma que lleva al bolsillo lo que el aula a veces no alcanza a repetir — con rigor pedagógico y la motivación de un juego bien diseñado.

---

## 2. El problema en datos (1 minuto)

- Resultados **Saber 11°** en matemáticas siguen siendo preocupantes a nivel nacional (informes ICFES 2024).
- En la región, muchos jóvenes llegan a educación superior **sin bases sólidas** en álgebra, estadística y geometría → deserción en carreras STEM.
- Los métodos tradicionales, sin apoyo digital estructurado, **no escalan** al ritmo de atención de un adolescente ni a la brecha entre colegios.

**Pregunta de investigación (nuestro norte):**  
¿Cómo una plataforma educativa gamificada puede mejorar el dominio de conceptos matemáticos fundamentales en educación media, preparando para Saber 11° y la transición a la universidad?

---

## 3. Por qué Cúcuta (1 minuto)

- **Contexto local:** colegios aliados y validación con **Universidad Simón Bolívar** (monitorías de contenido).
- **Equidad:** según datos del Ministerio TIC, la mayoría de jóvenes 15–24 años tiene **smartphone** → el aprendizaje móvil no es lujo, es oportunidad.
- **Nosotros somos de aquí:** Juan Sebastian Perez Galvis y Eduardo José Soto Herrera, Ingeniería de Sistemas, Cúcuta — el producto nace mirando a **grados 9, 10 y 11** de instituciones de la ciudad, no a un modelo genérico importado.

---

## 4. La solución en una frase (20 segundos)

**EULER** combina **micro-lecciones** (5–10 min), **gamificación** (XP, rachas, ranking) y **comunidad de aula** (grupos con código, chat con el profe) en una sola experiencia **web y móvil**.

Eslogan: **Domina las matemáticas.**

---

## 5. Demostración en vivo — guion (3–4 minutos)

Sugerencia: proyectar **https://pefcmeem-633d9-e5f18.web.app** o APK en el teléfono.

| Paso | Qué decir | Qué mostrar |
|------|-----------|-------------|
| 1 | “Entrada con cuenta real, sin atajos anónimos.” | Registro / login estudiante |
| 2 | “Personalizamos grado y meta Saber 11°.” | Onboarding breve |
| 3 | “El profe crea el grupo; el estudiante entra con **código**.” | Rol docente → código → estudiante se une |
| 4 | “Aprendizaje en dosis cortas, como recomienda la teoría de carga cognitiva.” | Una lección: teoría + ejercicio |
| 5 | “El esfuerzo se ve: XP y ranking del grupo.” | Ranking / estadísticas |
| 6 | “No es solo app: es **clase extendida**.” | Chat del grupo |
| 7 | “Transparencia académica.” | **Sobre EULER** (ℹ o Ajustes): equipo, documento del proyecto |

Si algo falla en red: mencionar **modo offline parcial** (catálogo local en assets) y que el MVP prioriza estabilidad en aula piloto.

---

## 6. Fundamento pedagógico (1 minuto — sin slides densos)

- **Aprendizaje significativo (Ausubel):** conectar con lo que el estudiante ya sabe antes de avanzar.
- **Carga cognitiva (Sweller):** lecciones cortas, un objetivo por bloque.
- **Experiencia y feedback (Kolb + gamificación):** practicar → feedback → repasar.
- **m-Learning y micro-learning:** estudiar en el bus, en la casa, entre clases.

No vendemos “puntos por puntos”: vendemos **hábito y dominio** medible.

---

## 7. Metodología y viabilidad (1 minuto)

- Investigación **aplicada**, enfoque **mixto** (resultados + experiencia de usuario).
- Fases: diseño de contenidos con USB y colegios → UX → desarrollo (este MVP) → piloto → escalamiento.
- **Sostenible:** monitorías estudiantiles reducen costo de producción de contenido.
- **Técnico:** Flutter + Firebase = un solo código para web y Android, despliegue en Hosting para que el jurado pruebe **sin instalar**.

---

## 8. Lo que ya está hecho vs. roadmap (45 segundos)

**Hoy (MVP presentable):**

- Auth, perfiles, roles estudiante/docente  
- Catálogo de cursos y lecciones con ejercicios  
- Grupos, ranking, chat  
- Web desplegada + APK release  
- Documentación académica y técnica en el repositorio  

**Siguiente fase:**

- Piloto formal en colegios de Cúcuta (pre/post test)  
- Más banco de ítems alineado a ICFES  
- Recordatorios de repaso espaciado  
- App iOS en tiendas  

---

## 9. Cierre emocional + llamado (30 segundos)

> Cada punto de XP en EULER es un minuto que un estudiante de Cúcuta decidió **no rendirse** con las matemáticas. Nosotros ponemos la tecnología; los colegios y la USB ponen la validación; ustedes, el jurado, nos ayudan a llevar esto de **prototipo** a **impacto real** en la frontera.

**Gracias. ¿Preguntas?**

---

## 10. Preguntas frecuentes del jurado (respuestas cortas)

**¿Por qué Flutter y no solo una web?**  
Un código, dos canales: navegador para demostración inmediata y APK para el estudiante que vive en el móvil.

**¿Qué pasa sin internet?**  
El catálogo base funciona desde el dispositivo; sincronización de perfil, grupos y chat requiere red (diseño consciente para el piloto).

**¿Cómo miden impacto?**  
Diseño cuasi-experimental previsto: pre/post en instituciones aliadas; este MVP es la herramienta de intervención.

**¿Privacidad?**  
Progreso local; datos de cuenta y grupo en Firestore con reglas restrictivas; sin vender datos a terceros.

**¿Diferencia con apps genéricas de matemáticas?**  
Enfoque **Saber 11°**, grupos con **código del colegio**, validación local USB/Cúcuta y narrativa en español para nuestra región.

---

## Anexo: datos de contacto del equipo

- **Juan Sebastian Perez Galvis** — Ingeniería de Sistemas  
- **Eduardo José Soto Herrera** — Ingeniería de Sistemas  
- **Institución / ciudad:** Cúcuta, Colombia · Febrero 2026  

**Demo:** https://pefcmeem-633d9-e5f18.web.app  

---

*Documento para defensa oral. Complementa `DOCUMENTO_PROYECTO_EULER.md` y `DOCUMENTACION_TECNICA_EULER.md`.*
