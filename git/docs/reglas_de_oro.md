# Reglas de Oro y Arquitectura del Proyecto ArzSuite

Este documento es la **fuente única de verdad** para el desarrollo en el proyecto **App ArzSuite**. Cualquier desarrollador que se integre al proyecto debe adherirse estrictamente a estas pautas para garantizar un código escalable, limpio y mantenible.

---

## ⛔️ 1. REGLA DE ORO DE UI: CERO VALORES HARDCODEADOS
Esta es la regla más crítica del entorno visual:
**Bajo ninguna circunstancia** un widget debe definir localmente ningún color, textura, altura (height), ancho (width), radio de borde (border radius), fuente, espaciado (padding/margin), o sombra.

Todos los valores de diseño deben extraerse obligatoriamente de la configuración global de Tema, la cual centraliza el estilo.

*   **Archivo fuente de Colores y Estilos (Tema Central):**
    `lib/core/theme/app_theme.dart`
*   **Archivos Auxiliares (Opcional si se separa):**
    `lib/core/theme/app_colors.dart`, `lib/core/theme/app_spacing.dart`

**Ejemplo INCORRECTO (Prohibido):**
```dart
Container(
  color: Colors.blue, // 🚫 MAL: Hardcodeado
  padding: EdgeInsets.all(15.0), // 🚫 MAL: Hardcodeado
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20), // 🚫 MAL: Hardcodeado
  )
)
```

**Ejemplo CORRECTO:**
```dart
Container(
  color: AppTheme.primaryColor, // ✅ BIEN: Viene del tema
  padding: const EdgeInsets.all(AppTheme.spacingMedium), // ✅ BIEN: Viene de las variables globales
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal), // ✅ BIEN
  )
)
```
Si necesitas usar el esquema del tema actual (`light` o `dark`), usa:
`Theme.of(context).colorScheme.primary`

---

## 📡 2. ENDPOINTS Y CONEXIÓN A CAKEPHP BACKEND
Todos los strings, URLs y rutas que conectan la App de Flutter con **CakePHP 5 (centro-backend)** conforman la capa de networking.

*   **Archivo único para Rutas de Endpoints:**
    `lib/core/network/api_endpoints.dart`
    *(Nunca dejar una URL hardcodeada en un repositorio de capa de datos, todo debe consumirse desde aquí).*
*   **Archivo central de Configuración de Red (Dio/HTTP):**
    `lib/core/network/api_client.dart`

**Regla:** Para agregar un nuevo endpoint de CakePHP, agrégalo estructuradamente en `api_endpoints.dart` (Ej. `ApiEndpoints.getUsers`, `ApiEndpoints.login`).

---

## 🔄 3. MANEJO DE ESTADO Y PROVIDERS DE INVALIDACIÓN (RIVERPOD)
El manejo de caché, el refresco de datos y las dependencias globales utilizarán Riverpod.

*   **Providers Globales y de Invalidación (Eventos del sistema):**
    `lib/core/providers/invalidation_providers.dart` (Para reglas que provocan resets o invalidan caché a nivel app).
    `lib/core/providers/global_providers.dart` (Para instancias globales compartidas, Ej: instancia de Dio o Supabase).
*   **Providers por Módulo (Lógica Local):**
    `lib/features/<nombre_modulo>/providers/`
    *(Aquí irán los repositorios y ViewModels específicos a cada módulo, garantizando el aislamiento de la lógica).*

**Regla:** Cuando un dato cambie en la base de datos o venga de un socket, se debe invocar a la ref global de Riverpod para invalidar `ref.invalidate(providerName)` en los archivos centralizados, obligando a los widgets a reconstruirse en base a su origen de datos real, no estados mutados localmente.

---

## 🧩 4. UBICACIÓN DE WIDGETS Y COMPONENTES REUTILIZABLES
La arquitectura de visualización está dividida para evitar el duplicado de componentes.

*   **Widgets Globales ("Dumb Widgets"):**
    `lib/core/widgets/`
    *(Ej. Botones personalizados globales, AppBars genéricos, Modales, Loaders. Estos componentes NO DEBEN acceder a la capa de datos de lógica [Riverpod/Providers] directamente, solo deben aceptar parámetros por constructor `onPressed`, `title`, etc).*
*   **Widgets de Módulo ("Smart Widgets"):**
    `lib/features/<nombre_modulo>/widgets/`
    *(Componentes estrictamente ligados a un caso de uso particular. Estos SÍ tienen permitido consultar su provider en la misma carpeta).*

---

## 📂 5. ESTRUCTURA DE LA ARQUITECTURA (FEATURE-FIRST)
Cualquier nueva funcionalidad grande (Auth, Dashboard, Usuarios, Ventas) se trata como un "Feature" aislado.

Cada Feature debe respetar la siguiente jerarquía interior bajo `lib/features/<nombre_modulo>`:
```
<nombre_modulo>/
 ├── models/             -> Definición de las entidades puras (DTOs/Mapeos).
 ├── repositories/       -> Conexión directa a api_client / Supabase para traer la data.
 ├── providers/          -> Puente StateNotifier/Riverpod para enlazar modelo y UI.
 ├── views/ (o pages/)   -> Las pantallas principales de dicho módulo.
 └── widgets/            -> Componentes de uso exclusivo dentro de esta vista.
```

---

## 🛡 6. MANTENIBILIDAD Y DOCUMENTACIÓN
*   Toda funcionalidad compleja o adición de estructura nueva **debe ser comentada obligatoriamente** en código (Dart doc comments `///`).
*   Los diagramas y procesos se actualizarán en esta carpeta `/git/docs/` conforme la app escale para llevar una auditoría limpia del proyecto.
