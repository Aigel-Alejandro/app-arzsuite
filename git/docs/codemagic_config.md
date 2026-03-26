# Datos de Configuración para Codemagic

Aquí tienes los datos exactos del proyecto de Arzsuite, listos para tu configuración en Codemagic:

- **Nombre exacto de los Flavors:** Actualmente **no hay flavors configurados** en el proyecto. Se utiliza la configuración por defecto (`debug`, `profile`, `release`).
- **Entry points (Target):** El archivo principal de entrada es `lib/main.dart`.
- **Bundle ID (iOS):** `mx.org.centrolibanes.app.arzsuite` (registrado en Xcode / `project.pbxproj`).
- **Application ID (Android):** `mx.org.centrolibanes.app.arzsuite` (registrado en `build.gradle.kts`).
- **Versiones (Workspace):**
  - **Flutter:** `3.41.2`
  - **Dart:** `3.11.0`
- **Pre-build scripts y Entorno:** **No tenemos scripts de pre-build** configurados. Actualmente el proyecto utiliza **Supabase** (cuyas credenciales están fijas en el `lib/main.dart`) por lo que no requieres inyectar archivos `.env` ni configuraciones nativas de Firebase (`google-services.json` / `GoogleService-Info.plist`) antes de construir la app.

---

## Credenciales de Firma (Keystore para Android)
La llave para firmar los releases de Android se ha generado con los siguientes datos para subir a Codemagic:

- **Ruta local de la llave:** `~/arzsuite_centrolibanes.jks`
- **Key Alias:** `arzsuite`
- **Store Password:** `arzsuite2026`
- **Key Password:** `arzsuite2026`
