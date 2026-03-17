# Conexiones

Este archivo registra a qué servicios se conecta nuestra App.

---

### 1. Supabase
Servicios primarios de datos, posiblemente para autenticación rápida o realtime.
- **Project URL:** `https://jgxwzxqbispwempgetrh.supabase.co`
- **Public Key:** `sb_publishable_z3Iw5Cnoy5F7gHViVwZG2A_455RJrPR`

### 2. CakePHP 5 Backend (`centro-backend`)
APIs personalizadas para ejecutar la lógica del ecosistema.
- **Base Endpoint:** `[Aquí se documentará el endpoint productivo/staging que consumiremos mediante Dio]`
- **Autenticación (Si aplica):** JWT Tokens o Bearer Headers provistos por centro-backend o enlazados a Supabase.
