# Plan de Desarrollo Integral: Módulo de Actividades y Curso de Verano

Este documento organiza secuencialmente las etapas, hitos y requerimientos del desarrollo, entrelazando las actividades regulares e institucionales del Centro Libanés junto con el módulo especializado del Curso de Verano, garantizando un ecosistema modular, re-utilizable y sumamente organizado.

---

## 🏗️ Fase 1: Arquitectura Base y Backend
*Estado actual: Mayormente completada en desarrollo y estructura de BDD.*

1. **Revisión de Endpoints de Actividades**:
   - `GET`, `POST`, `PUT`, `DELETE` en `Api/Deportivo/ActividadesController.php`. (✅ Listo)
   - Suministro de catálogos (`/formData`). (✅ Listo)
2. **Revisión de Curso de Verano (Backend)**:
   - Pagos centralizados cruzados con la tabla `payments`.
   - Generación dinámica de RFCs y fechas de nacimiento. (Validado en perfiles).
3. **Estandarización de Esquema**:
   - Asegurarnos que un "Curso de Verano" actúe armónicamente ya sea como un tipo especial de `Actividad` (`tipo: otro` ó `curso_verano`), o que compartan la estructura base de pagos (relación con `ConceptosPago`).

---

## 💻 Fase 2: Panel Administrativo - Módulo Núcleo de Actividades (Angular)
*Estado actual: En progreso (Iniciando Scaffolding).*

1. **Estructura y Ruteo Módulo Actividades**:
   - Registrar endpoints en el `app.routes.ts` (`/actividades`, `/actividades/lista`, `/actividades/crear`, `/actividades/editar/:id`).
   - Desarrollo del `ActividadesService` para interconectar Angular con CakePHP.
2. **Catálogo Principal (CRUD)**:
   - **Listado (`ActividadesLista`)**: Datatable premium con filtros predeterminados (por Club, estado Activa/Inactiva).
   - **Formulario (`ActividadesForm`)**: Formulario reactivo general. Variables esenciales (Costos, Modos de Mensajería, Fechas, Iconos y Colores).
3. **Manejo de Respuestas UI**:
   - Implementación de `ToastAlerts` para dar feedback estético y suave al administrador.

---

## ⚙️ Fase 3: Gestión Avanzada y Profunda (Angular)
*Estado actual: Pendiente.*

La actividad general sirve como el paraguas. Ahora se administran sus "hijos".
1. **Vista de Detalle 360 (`ActividadesVer`)**:
   - Pantalla integradora que muestra los "stats" clave de la actividad y funciona como sub-dashboard para sus anexos.
2. **Sub-módulo Grupos y Categorías**:
   - Asignación de rangos de edades.
   - Administración inteligente de cupos (`cupo_maximo`, `cupo_ocupado`).
3. **Sub-módulo Equipos y Horarios**:
   - Asignación de Coaches por equipo.
   - Cronograma semanal (días, horas de inicio-fin y lugar de impartición).
4. **Criterios de Evaluación**:
   - Parametrización de qué es lo que se calificará para los usuarios inscritos.

---

## ☀️ Fase 4: Gestión Administrativa del Curso de Verano (Angular)
*Estado actual: Integración con Frontend Pendiente.*

Una vez armadas las actividades generales, orquestamos la parte administrativa específica del curso de verano.
1. **Dashboard y Métricas del Curso de Verano**:
   - Vista especializada de inscritos al curso.
   - Seguimiento de estados de pago e historial transaccional (vía trigger automático de `payments`).
2. **Flujos Operativos del Curso**:
   - Exportación de listas de invitados / asistentes.
   - Monitoreo de invitados/residentes de los socios titulares registrados al curso.

---

## 📱 Fase 5: Experiencia de Usuario - App Móvil (Flutter / Arzsuite)
*Estado actual: Preparación final del flujo en UI.*

1. **Consumo de Actividades**:
   - Directorio premium en la aplicación para listar actividades generales con su diseño asignado (colores + iconos).
   - Posibilidad de pre-inscripción o manifestar interés (si aplica).
2. **Consumo Final del Curso Verano**:
   - Refinamiento de la ventana de registro al curso.
   - Invalidación fluida de _Providers_ para repintar imperceptiblemente la UI tras un registro/pago exitoso.

---

### 🚀 Orden de Ejecución e Hitos Inmediatos
Para seguir nuestro sprint eficientemente, el siguiente paso inmediato es abordar la **Fase 2 (Paso 1 y 2)**:
1. Crear el `actividades.service.ts` en Angular.
2. Crear la estructura de componentes para la tabla `/lista` y el formulario `/crear`.
3. Integrar las rutas.
