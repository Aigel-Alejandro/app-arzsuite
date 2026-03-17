# Carpeta Central de Widgets Globales

Esta carpeta está diseñada **EXCLUSIVAMENTE** para componentes de UI compartidos y altamente reutilizables a lo largo de toda la aplicación.  

## Reglas para crear un Global Widget (`lib/core/widgets/`)
1. **Dumb Widget:** No debe conectarse a `Riverpod`, `Dio`, o `Supabase` directamente. (Sin `ConsumerWidget` si es posible).
2. **Inyección por Parámetros:** La data debe llegar por constructores (`String title`, `VoidCallback onPressed`, etc).
3. **Estricta dependencia de `app_theme.dart`:** Utiliza `Theme.of(context)` o `AppTheme`, sin hardcodear padding o colores.
4. **Ningún Widget Específico de Negocio:** Aquí no va una lista de 'Usuarios'. Aquí va un 'Botón Genérico', un 'Loader Personalizado' o un 'Input Text'.

Los **Smart Widgets** que pertenecen a un módulo, deben ir dentro del mismo módulo de vista, como:  
`lib/features/auth/widgets/`
