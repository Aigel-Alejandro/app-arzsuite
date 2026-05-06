# Plan de Trabajo: Gestión de Permisos Familiares

Este documento detalla los pasos para implementar el módulo de "Gestión de Permisos Familiares", el cual permitirá al **Socio Titular** personalizar qué módulos (Finanzas, Salud, Vehículos, etc.) pueden visualizar sus familiares beneficiarios. 

## FASE 1: Backend (CakePHP / SGI)
El objetivo es preparar la base de datos y los endpoints para que la aplicación móvil pueda consultar y persistir la configuración de permisos.

### 1. Análisis y Configuración de Base de Datos
- [x] **Hallazgo del Análisis:** Tras revisar la base de datos (MariaDB) del backend (`centro`), se determinó que las tablas de permisos actuales (`app_permissions`, `user_specific_permissions`) están vacías o más orientadas a usuarios administrativos. No existe una estructura directa para asignar permisos a nivel `socio`.
- [x] **Creación de Nueva Tabla (`app_socio_permissions`):** Se creará una nueva migración en CakePHP para generar una tabla exclusiva para esto. **Importante:** La migración deberá incluir comentarios descriptivos tanto a nivel de la tabla como en cada uno de los campos (usando la propiedad `comment`).
    *   **Estructura propuesta:**
        *   `id` (INT, Primary Key): Identificador único del registro de permiso.
        *   `socio_id` (INT): El ID del familiar (beneficiario) al que aplica el permiso.
        *   `permission_key` (VARCHAR): Clave del permiso (ej. `financial.view`, `health.medical_data`, `profile.vehicles`).
        *   `is_granted` (BOOLEAN): `1` (permitido) o `0` (denegado).
        *   `granted_by` (INT): El ID del Socio Titular que modificó el permiso (útil para auditoría).
        *   `created_at`, `updated_at` (DATETIME): Fechas de creación y actualización del registro.
- [x] **Ventaja:** Esta estructura relacional asegura que la lógica de permisos sea escalable, auditable, y mucho más rápida de consultar en comparación con el uso de campos JSON.

### 2. Actualización del Endpoint de Consulta (GET)
- [x] **Modificación de Endpoint de Miembros:** Ajustar la respuesta del endpoint que alimenta la información de la familia (`profile.associatedMembers`).
- [x] **Inclusión de Datos:** Anexar un arreglo o listado de permisos actualmente concedidos a cada miembro devuelto.

### 3. Creación del Endpoint de Guardado (POST/PUT)
- [x] **Ruta propuesta:** `POST /api/arzsuite/profile/updateFamilyPermission`
- [x] **Seguridad y Validación:** Validar estrictamente que el usuario autenticado (quien realiza la petición) sea efectivamente el **Socio Titular** vinculado al `{memberId}`.
- [x] **Lógica de Persistencia:** Manejar la inserción o actualización (upsert) en la tabla `app_socio_permissions`.

---

## FASE 2: Frontend (Flutter - ArzSuite)
Con el backend listo, se construirá y conectará la interfaz de usuario en la aplicación móvil.

### 4. Actualización de Modelos de Datos
- [x] **Extensión de Modelo:** Actualizar el `SubMemberModel` (o equivalente) para incluir la propiedad de permisos (ej. `List<String> permissions`) recibidos del backend.

### 5. Lógica de Estado (Riverpod)
- [x] **Nuevo Método en Provider:** Agregar la función `updateFamilyMemberPermission` dentro de `ProfileNotifier`.
- [x] **Integración de API:** Este método realizará la llamada HTTP al nuevo endpoint y actualizará el estado local de Riverpod de forma optimista (para evitar recargas de pantalla innecesarias).

### 6. Desarrollo de Interfaz (`FamilyPermissionsView`)
- [x] **Pantalla Dedicada:** Crear una nueva vista limpia y accesible.
- [x] **Componentes de UI:**
    *   Iteración sobre familiares usando tarjetas tipo *Accordion* (`ExpansionTile`).
    *   Implementación de *Toggle Switches* (similares a los de notificaciones) para habilitar/deshabilitar módulos:
        *   Saldos y Finanzas
        *   Información de Salud
        *   Beneficiarios Legales
        *   Mis Vehículos
        *   Datos Personales/Fiscales
- [x] **Feedback Visual:** Mostrar indicadores de carga e informativas (`ToastAlerts.showSuccess`) al guardar cambios.

### 7. Punto de Entrada en la App
- [x] **Navegación:** Integrar un botón "Control Familiar" o "Permisos de Accesos" en la pantalla de perfil principal (Grid) o dentro de "Ajustes de la App".
- [x] **Restricción de Visibilidad:** Asegurarse de que este acceso sólo se muestre si el usuario activo es Titular.

---

## FASE 3: Pruebas y Validación (QA)
Para garantizar la calidad y seguridad del módulo, se deben ejecutar los siguientes flujos de prueba:

### 8. Pruebas de Interfaz y Lógica del Titular
- [x] **Visibilidad del Módulo:** Iniciar sesión con una cuenta **Titular** y verificar que la sección "Control Familiar (Permisos)" aparezca en los ajustes del perfil.
- [x] **Listado de Familiares:** Comprobar que en esta sección se listen correctamente *todos* los miembros asociados a la membresía del titular.
- [x] **Activación/Desactivación Optimizada:** Encender y apagar los interruptores (switches) de permisos y confirmar que la UI responda inmediatamente (sin recargas) y muestre un Toast de éxito.
- [x] **Persistencia de Datos:** Cambiar el estado de varios permisos, cerrar completamente la aplicación, volver a entrar y verificar que los estados de los switches se mantengan tal como se dejaron.

### 9. Pruebas de Seguridad y Restricciones (Backend / Frontend)
- [x] **Ocultamiento para Sub-miembros:** Iniciar sesión con una cuenta de **Beneficiario/Familiar** y confirmar que la sección "Control Familiar" NO es visible en ninguna parte de su interfaz.
- [x] **Auditoría en Base de Datos:** Entrar a la base de datos (MariaDB) en la tabla `app_socio_permissions` y validar que el campo `granted_by` registra correctamente el `id` del Titular que hizo la modificación y que `is_granted` coincide con lo elegido.
- [x] **Rechazo de Accesos Cruzados:** Si es posible vía Postman/API, intentar mandar el `member_id` de un familiar de OTRA membresía distinta usando el token de un Titular diferente. El backend (Punto 3) debe regresar un error de seguridad (400) impidiendo el guardado.

### 10. Pruebas de Impacto (Requisito Futuro para la App)
- [x] **Bloqueo Efectivo de Módulos:** Iniciar sesión como un Sub-miembro que tiene un permiso denegado (Ej. `financial.view` = 0) y comprobar que al intentar entrar a "Saldos y Finanzas" o "Actividades", la aplicación le bloquee el acceso con un mensaje de "No tienes permisos otorgados por el titular". *(Nota: La implementación de este bloqueo en cada vista específica se hará progresivamente según las necesidades de cada módulo)*.
