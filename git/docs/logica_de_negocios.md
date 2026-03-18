# Lógica de Negocios y Arquitectura de Sitios

Este documento describe la lógica de negocios central del proyecto **App ArzSuite** y su interconexión en el ecosistema de Centro Libanés.

## Ecosistema de Plataformas (3 Sitios)
La arquitectura está compuesta por tres sitios que interactúan entre sí. **El Sitio 2 es el eje central y funcional de toda la base de datos.**

1. **Sitio 1 (NetSuite - CRM Oracle):** 
   - Plataforma externa donde se realiza el registro principal de usuarios, facturación, etc.
2. **Sitio 2 (Centro Libanés - CakePHP & Frontend Web):** 
   - Funciona como administrador de inventarios, consulta de usuarios y administrador web para el Sitio 3. 
   - **Es el eje funcional y central de la base de datos.**
   - Aquí se exponen los endpoints que consume la app (vía `https://arzsuite.centrolibanes.org.mx/api/`).
3. **Sitio 3 (App ArzSuite - Flutter):** 
   - Aplicación móvil hecha en Flutter para centralizar servicios a los usuarios (ej. registro para cursos de verano). No interactúa directamente con el Sitio 1, solo se comunica con el Sitio 2.

## Flujo de Autenticación (Login) y Segregación de Roles

La duda principal en el mapa de proceso sobre el inicio de sesión se resuelve con el siguiente flujo de comunicación, donde **la App (Sitio 3) delega el login completamente al backend de CakePHP (Sitio 2):**

1. **Solicitud de Login (Contexto de App):** El usuario ingresa sus credenciales en la App (Sitio 3) y esta hace una petición POST al endpoint del **Sitio 2**: `/api/auth/login`. **Punto Clave:** La petición debe incluir un identificador (ej. un header `X-Client-App: arzsuite-mobile` o un parámetro en el body) que le indique al Sitio 2 que el login proviene de la aplicación de socios (Sitio 3).
2. **Validación en Sitio 2:** El backend del **Sitio 2** recibe la petición y busca al usuario en su base de datos local (eje central).
3. **Sincronización (Si no se encuentra el usuario):** Si el **Sitio 2** NO encuentra al usuario, este (el backend) se comunica automáticamente con el **Sitio 1 (NetSuite)** para consultarlo. 
4. **Segregación de Alcance (El caso de "José"):** Si el usuario existe y resulta que tiene múltiples roles (ej. es Administrador del Sitio 2 y también es Socio/Cliente normal), el backend (Sitio 2) utiliza el contexto del paso 1. Como sabe que la petición viene del **Sitio 3 (App de Usuarios)**, el backend **emite un Token de Sesión (JWT) restringido única y exclusivamente al alcance de "Socio"**. 
   - Las credenciales de administrador de José no se envían ni se habilitan en esta sesión. Así se garantiza que sus alcances no se mezclen.
5. **Respuesta final:** El **Sitio 2** devuelve a la App (Sitio 3) los datos de sesión limitados al rol de cliente. Si no existe en ningún lado, devuelve un error de autenticación.

## Modelos de Datos Proyectados
1. **AppUser:** Modelo devuelto por el login, incluye su `role` (Admin, Coordinator, Teacher, Parent).
2. **ChildProfile & MedicalRecord:** Representa a cada beneficiario, enlazado a sus historiales médicos.
3. **Activity / Tournament / Match:** Control de flujos de inscripciones y agendas.
4. **ChatChannel & ChatMessage:** Para la comunicación bidireccional, o restrictiva (modo "Solo respuesta" / "Solo lectura").

## Flujo Principal de Operaciones (Módulo Actividades)

El sistema discrimina las visualizaciones por Rol en tiempo de ejecución a través del Router Principal de Actividades (`ActivitiesDashboardView`):
1. **Tutor (+2 hijos):** La app detecta múltiples dependientes y arroja un selector visual. Al elegir uno, entra a su expediente único y dividido en pestañas (Entrenamientos, Torneos, Ficha Médica).
2. **Tutor (1 hijo):** El paso de selección ocurre en automático y entra a las pestañas directas del hijo.
3. **Papá / Tutor Confirmación:** Tiene potestad sobre la ficha médica y puede otorgar visibilidad (Público/Privado) de documentos al club. Para los Torneos, confirma asistencia en pantallas interactivas que notifican de vuelta a `centro-backend`.
4. **Profesor (Home del Docente):** Tiene vistas exclusivas para "Pase de Lista Rápido", "Crear Evaluaciones (Sliders)" y modificar en tiempo real la localidad/resultados de los partidos, forzando la invalidación Global en la familia correspondiente al enviar el request a CakePHP.
