# Planificación de Frontend (App Móvil Flutter) - Módulo de Actividades

Todo el esfuerzo de interfaces de usuario para este sprint estará dedicado a la aplicación móvil (`app-arzsuite` - Flutter), garantizando una experiencia de usuario (UX) sumamente interactiva, de primer plano e intuitiva. El objetivo es que la app sea el centro de control del socio para saber **dónde, cuándo y con/contra quién** interactúa.

## 1. Arquitectura Base y Vistas Existentes
Dentro de `lib/features/activities` ya contamos con una pre-estructura de vistas que guiaremos y refinaremos con las mejores prácticas de UI/UX que venimos implementando en la app:
- **Dashboards**: `activities_dashboard_view.dart`, `activities_list_view.dart` (Exploración premium).
- **Inscripción y Gestión**: `activity_subscription_view.dart`, `child_selector_view.dart`.
- **Competencias**: `match_detail_view.dart`.
- **Interacción**: `activity_chat_view.dart`.
- **Staff/Coaches**: `trainer_dashboard_view.dart`, `trainer_attendance_view.dart`, `trainer_evaluation_view.dart`.

## 2. Flujo 1: Clases con Cupo y Horario (Estilo Gimnasio - Pilates, etc.)
La dinámica debe ser rápida y de un par de toques (Notificación -> Inscripción -> Asistencia).
*   **Directorio Dinámico**: El socio ve las clases disponibles de sus clubes.
*   **Reserva de Cupo (`activity_subscription`)**: Visualiza horarios específicos (ej. L-M-V, 8-9am) y la disponibilidad de cupos en tiempo real.
*   **Gestión de Citas**: Al "Inscribirse", asegura su lugar. Podrá visualizar su agenda en un widget de calendario premium (`premium_horizontal_calendar.dart`).
*   **Check In / Out**: Un ciclo de vida claro para cada clase; asiste y sale.

## 3. Flujo 2: Deportes de Equipo, Partidos y Torneos (Fútbol, Padel, etc.)
A diferencia de clases estables, aquí la UX se enfoca en la competitividad y calendarios rotativos.
*   **Visualización de Partidos (`match_detail_view`)**: Pantallas diseñadas para presentar la información de encuentros. ¿Cuándo es mi próximo partido? ¿A qué hora? 
*   **Con/Contra Quién**: Identidad visual fuerte indicando Escuadra Local vs Visitante.
*   **Torneos y Calificaciones**: Tablas de posiciones, seguimiento de "Minimundialitos", visualización de anotaciones / goleo.
*   **Gestión del Coach (`trainer_dashboard_view`)**: Permite a los profesores o árbitros capturar asistencias y calificaciones/marcadores en el lugar.

## 4. Requisitos Hacia el Backend (CakePHP - API de Arzsuite)
Dado que pausamos el esfuerzo en el Admin panel (Angular), el backend necesita exponer exactamente lo que la App va a consumir de forma masiva:
*   **Endpoint de Descubrimiento (`GET /api/arzsuite/actividades`)**: Catálogo estructurado.
*   **Endpoint de Agenda (`GET /api/arzsuite/actividades/mis-horarios`)**: Traer el itinerario de la semana para el socio activo y sus dependientes.
*   **Endpoint Transaccional (`POST /api/arzsuite/actividades/reservar`)**: Inscribir un socio/dependiente a un `HorarioEntrenamiento` particular bloqueando el `cupo_ocupado`.
*   **Endpoint Torneos (`GET /api/arzsuite/torneos/mis-partidos`)**: Extraer roles de juego y estadísticas rápidas.

## 5. Próximos Pasos (Arranque de Programación)
1. **Modelos y Proveedores (Flutter)**: Interconectar los repositorios en Dart con la estructura acordada en CakePHP.
2. **Capa UI (Flutter)**: Abrir `activities_list_view.dart` y maquetar el directorio interactivo aplicando la línea de UX premium (tarjetas visuales, insignias de estado, selectores sin fricción).
3. **Backend (`ActividadesController.php` - Móvil)**: Crear la salida en JSON perfecta para pintar estos flujos sin procesamientos pesados en el celular.
