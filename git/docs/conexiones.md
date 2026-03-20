# Conexiones

Este archivo registra a qué servicios se conecta nuestra App.

---

### 1. Supabase
Servicios primarios de datos, posiblemente para autenticación rápida o realtime.
- **Project URL:** `https://jgxwzxqbispwempgetrh.supabase.co`
- **Public Key:** `sb_publishable_z3Iw5Cnoy5F7gHViVwZG2A_455RJrPR`

### 2. CakePHP 5 Backend (`centro-backend` - **Sitio 2 Central**)
APIs y backend principal del ecosistema. Este es el eje funcional y central de la base de datos de la app.
- **Base Endpoint (Raíz):** `https://arzsuite.centrolibanes.org.mx/api/`
- **Endpoint Login:** `auth/login`
- **Autenticación:** JWT Tokens o Bearer Headers provistos por centro-backend.

### 3. Endpoints de CakePHP (Módulo Actividades y Entrenamientos)

Para las operaciones de la Fase 1 (Piloto Fútbol) y Fase 2, la aplicación consume los siguientes endpoints del Sitio 2:

**Suscripciones y Alumnos:**
- `GET /api/v1/activities` - Lista de actividades disponibles.
- `GET /api/v1/activities/subscribed` - Actividades inscritas por el usuario/hijos.
- `POST /api/v1/activities/{id}/subscribe` - Solicita inscripción de un menor.
- `GET /api/v1/tutor/beneficiaries` - Lista de hijos asociados al perfil del tutor.
- `POST /api/v1/child/documents/upload` - Envío multipart de documentos al repositorio unificado.
- `POST /api/v1/child/{id}/medical` - Inserta/Actualiza la ficha médica (alergias, pólizas).

**Operaciones del Profesor / Coach:**
- `POST /api/v1/activities/attendance` - Guarda pase de lista de entrenamiento masivamente.
- `POST /api/v1/activities/evaluations` - Envía calificaciones de criterios (del 1 al 5).
- `POST /api/v1/activities/tournament/match` - Crea o actualiza ubicaciones y marcadores de un partido.
- `POST /api/v1/activities/chat/{channelId}/send` - Envía mensaje interactivo en chat en vivo.

**Inscripción Curso de Verano:**
- `GET /api/v1/summer-course/titular` - Buscador de socios titulares por nombre o número de acción.
- `GET /api/v1/summer-course/relationships` - Obtiene las opciones de catálogo para el parentesco de invitados con el titular.
- `GET /api/v1/summer-course/titular/{id}/family` - Recupera la lista de beneficiarios enlazados al titular.
- `POST /api/v1/summer-course/guest` - Valida y pre-registra los datos de un invitado externo.
- `POST /api/v1/summer-course/registration` - Registra los participantes y genera la Orden de Venta en NetSuite via CakePHP.

**Legales:**
- `GET /api/v1/terms/latest` - Busca la versión activa del acuerdo para firma o confirmación obligatoria.
- `POST /api/v1/terms/accept` - Registra la aceptación electrónica del usuario.
