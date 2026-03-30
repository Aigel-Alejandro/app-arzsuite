# Análisis del Backend - Módulo de Actividades

El backend (CakePHP) ya cuenta con una estructura base para manejar el módulo de Actividades (`deportivo_actividades`).

## 1. Entidad Principal `Actividades` (`ActividadesTable.php`)
Los campos de la tabla `actividades` son:
- `id` (PK)
- `club_id` (FK a Clubes)
- `nombre` (varchar 100)
- `descripcion` (text)
- `icono` (varchar 100)
- `color` (varchar 7, e.g. '#FFFFFF')
- `tipo`: Enum (`deporte_equipo`, `deporte_individual`, `arte`, `otro`)
- `modo_mensajeria`: Enum (`bidireccional`, `solo_respuesta`, `solo_lectura`)
- `tiene_costo`: Boolean
- `fecha_inicio`: Date
- `fecha_fin`: Date
- `monto`: Decimal
- `is_active`: Boolean
- Auditoría: `created_by`, `created_at`, `updated_at`, `deleted_at`

### Relaciones
- **Belongs To**: `Clubes`, `Users` (created_by)
- **Has Many**: 
  - `GruposCategorias` (Tiene relación con `Equipos`, y a su vez con `HorariosEntrenamiento`)
  - `CriteriosEvaluacion`
  - `Torneos`
  - `ConceptosPago`
  - `CoordinadoresActividad`

## 2. API Endpoints (`ActividadesController.php`)
El controlador base es `AppDeportivoController`. Los permisos se validan mediante la constante de módulo `deportivo_actividades` y submódulo `actividades.lista`.

| Método HTTP | Endpoint                         | Acción Controlador | Descripción |
|-------------|----------------------------------|--------------------|-------------|
| GET         | `/api/deportivo/actividades/formData` | `formData`         | Retorna datos requeridos para los selectores del formulario (Ej: `clubes`, enum `tipos`). |
| GET         | `/api/deportivo/actividades`     | `index`            | Listado de actividades. Soporta filtros `club_id` y `activa`. Contiene la relación basica con `Clubes`. |
| GET         | `/api/deportivo/actividades/:id` | `view`             | Detalle completo de la actividad. Retorna datos anidados: `GruposCategorias` > `Equipos` > `HorariosEntrenamiento` y `CriteriosEvaluacion`. |
| POST        | `/api/deportivo/actividades`     | `add`              | Crea una nueva actividad. Registra log de acción (`crear_actividad`). |
| PUT/PATCH   | `/api/deportivo/actividades/:id` | `edit`             | Edita una actividad. Registra log de acción (`editar_actividad`). |
| DELETE      | `/api/deportivo/actividades/:id` | `delete`           | Soft delete (marca `deleted_at`). Registra log de acción (`eliminar_actividad`). |

## 3. Consideraciones y Siguientes Pasos
- **Listado Básico**: El API está completamente listo para operaciones CRUD en la tabla `actividades`.
- **Anidación**: La vista de detalle (`view`) expone una rica jerarquía que será muy útil en el frontend (visualización de grupos, equipos y horarios).
- **Relaciones con Costos**: Hay un indicador `tiene_costo` y un `monto`, y una relación con `ConceptosPago` que requiere una consideración especial si el módulo se enlaza con facturación unificada más adelante.
