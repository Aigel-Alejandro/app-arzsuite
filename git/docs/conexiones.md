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
