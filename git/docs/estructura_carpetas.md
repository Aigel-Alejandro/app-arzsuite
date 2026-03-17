# Estructura de Carpetas

A continuación se detalla la estructura principal del proyecto Flutter (App ArzSuite).

```text
lib/
 ├── core/              # Configuraciones globales
 │   ├── theme/         # Archivo 'app_theme.dart' (Estilos centralizados CSS-like)
 │   └── network/       # Configuración global para conectar APIs (api_client usando dio)
 ├── features/          # Desarrollo orientado por dominio o funcionalidades
 │   ├── auth/          # Ejemplo: Vistas y controladores para Iniciar Sesión (Supabase)
 │   └── home/          # Vista principal de la app
 ├── providers/         # Archivos para inyección de dependencias y gestión del estado (Riverpod)
 └── main.dart          # Entrypoint de inicialización de Supabase y ProviderScope
```

> **Nota para Riverpod**: La función que Riverpod cubre se le conoce como **"Inyección de Dependencias"** y **"Gestión de Estado"**. Riverpod se asegura de que cualquier dato o conexión a un backend (como el CakePHP 5 o Supabase) se exponga globalmente y solo cuando es necesario, sin necesidad de pasar referencias manuales pantalla por pantalla.
