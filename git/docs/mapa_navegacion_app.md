# Mapa de Navegación de Módulos (App ArzSuite)

Este documento detalla el mapa de navegación exacto y la estructura de vistas (pantallas) de todos los módulos que componen la aplicación, agrupados por su funcionalidad principal.

## 1. Autenticación (Auth)
- **Inicio de Sesión (`login_view.dart`)**: Vista principal de autenticación donde el socio o usuario ingresa a la aplicación.

## 2. Inicio / Menú Principal (Home)
- **Dashboard Principal (`home_view.dart`)**: Punto de entrada una vez que el usuario está autenticado. Desde aquí se distribuye la navegación hacia todos los demás módulos de la aplicación (Actividades, Torneos, Perfil, etc.), dependiendo de los permisos y estado del usuario.

## 3. Actividades Deportivas y Culturales (Activities)
*Contiene todo lo relacionado con la exploración, inscripción, gestión y seguimiento de clases/actividades.*

- **Dashboard de Actividades (`activities_dashboard_view.dart`)**: Pantalla principal resumen del módulo.
- **Catálogo / Vistas de Actividades (`activities_list_view.dart`)**: Lista de actividades disponibles para descubrir e inscribirse.
- **Proceso de Inscripción (`activity_subscription_view.dart`)**: Flujo completo de registro en una actividad específica.
- **Términos y Condiciones (`activity_terms_view.dart`)**: Pantalla de aceptación de reglas por actividad.
- **Gestión de Reservas (`mis_reservas_view.dart`)**: Vista donde el usuario puede administrar, ver y cancelar sus clases/actividades inscritas.
- **Chat de Actividad (`activity_chat_view.dart`)**: Canal de comunicación interno para la clase.
- **Detalle de Partido (`match_detail_view.dart`)**: Información específica si la actividad implica un encuentro deportivo.
- **Gestión Familiar (Asociada a Actividades):**
  - **Selector de Hijos (`child_selector_view.dart`)**: Para inscribir a menores dependientes.
  - **Perfil del Hijo (`child_detail_profile_view.dart`)**: Detalle específico del menor.
  - **Formulario Médico Infantil (`child_medical_form_view.dart`)**: Ficha médica requerida para ciertas actividades.
  - **Perfil del Tutor (`tutor_profile_view.dart`)**: Información del responsable.
- **Vistas del Entrenador (Trainer):**
  - **Dashboard Entrenador (`trainer_dashboard_view.dart`)**: Vista exclusiva para los profesores/entrenadores.
  - **Pase de Lista (`trainer_attendance_view.dart`)**: Toma de asistencia para los alumnos de la actividad.
  - **Evaluación (`trainer_evaluation_view.dart`)**: Sistema para evaluar el desempeño de los inscritos.

## 4. Torneos (Tournaments)
*Módulo enfocado a los eventos competitivos y torneos del centro.*

- **Dashboard de Torneos (`tournaments_dashboard_view.dart`)**: Pantalla de inicio con los torneos activos y disponibles.
- **Inscripción a Torneos (`tournament_enrollment_view.dart`)**: Flujo para registrarse en un torneo específico.
- **Mis Torneos (`tournament_my_detail_view.dart`)**: Detalle y seguimiento de los torneos en los que el usuario está participando.

## 5. Curso de Verano (Summer Course)
*Módulo complejo de wizard por pasos para la gestión e inscripción completa al curso de verano.*

- **Wizard de Inscripción (`summer_course_wizard_view.dart`)**: Contenedor principal que maneja el flujo de registro.
  - **Paso 1 - Búsqueda de Titular (`step1_search_titular.dart`)**
  - **Paso 2 - Selección de Beneficiarios (`step2_beneficiaries.dart`)**
  - **Paso 3 - Registro de Invitados (`step3_guests.dart`)**
  - **Paso 4 - Selección de Semanas (`step4_weeks.dart`)**
  - **Paso 5 - Confirmación y Resumen (`step5_confirmation.dart`)**
- **Modal de Inscripción Activa (`summer_course_active_registration_modal.dart`)**: Interfaz para visualizar o retomar el estado de un registro en proceso.
- **Escáner de Curso de Verano (`summer_course_scanner_view.dart`)**: Vista de lectura de códigos (QR/Barras) para control de acceso al curso.

## 6. Perfil y Configuración (Profile)
*Módulo para administrar la identidad, finanzas y salud del usuario.*

- **Mi Perfil (`profile_view.dart`)**: Vista central que gestiona la información personal, credencial digital, familiares, configuración, finanzas, vehículos y control de permisos (titular).
- **Perfil Médico (`health_view.dart`)**: Vista dedicada a los datos de salud, alergias y contactos de emergencia del usuario.
