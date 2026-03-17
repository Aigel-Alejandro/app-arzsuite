# Guía de Diseño - ArzSuite

Esta guía establece los principios visuales y técnicos para mantener la coherencia estética en la aplicación ArzSuite. Se basa en una estética **minimalista, elegante, eficiente y limpia**.

---

## 🎨 1. Paleta de Colores

La aplicación utiliza un sistema de temas dinámicos (Claro/Oscuro). Los colores están centralizados en `lib/core/theme/app_theme.dart`.

### Colores de Marca (Primarios)
- **Primario (700):** `#406EBA` - Utilizado para acciones principales.
- **Primario Oscuro (800):** `#1D3D79` - Utilizado para contrastes y estados activos.
- **Accento (Solid):** `#87700B` - Dorado institucional para estados de éxito o alerta.
- **Énfasis (Solid):** `#B39716` - Dorado vibrante para llamadas a la acción secundarias.
*Nota: Se priorizan colores sólidos sobre degradados para mantener la limpieza visual.*

### Colores Neutros
Se utiliza una escala de grises para el texto, fondos y bordes:
- **N900:** `#141414` (Texto principal en Light, fondo en Dark)
- **N100:** `#E8E8E8` (Fondo alternativo, bordes suaves)
- **N50:** `#F6F6F6` (Fondo de Scaffold en Light)

---

## 📐 2. Geometría y Espaciado

### Bordes Redondeados (Border Radius)
Para mantener la elegancia y limpieza, se utiliza un radio de curvatura consistente:
- **Global:** `20.0px` - Aplicado a Cards, Inputs y Botones principales.
- **Medium:** `12.0px` - Aplicado a componentes secundarios.
- **Small:** `8.0px` - Aplicado a micro-componentes.

### Espaciado (Layout)
Seguimos una grilla basada en 8px:
- **Small:** `8.0px`
- **Medium:** `16.0px`
- **Large:** `24.0px`

---

## ⌨️ 3. Tipografía

- **Fuente Principal:** `Montserrat` ( vía GoogleFonts )
- **Estilo:** Moderno, geométrico y altamente legible. Ideal para dar una sensación de robustez y dinamismo a la marca ArzSuite.

---

## ⏺ 4. Componentes y Estados

### Inputs
- **Fondo:** `#FFFFFF` (Light) / `#373737` (Dark)
- **Borde:** `1.0px` sólido, color neutral suave.
- **Foco:** Cambia el borde a color primario con un grosor de `2.0px`.
- **Radio:** `20.0px` (Global).

### Botones
- **ElevatedButton:** Fondo primario, texto blanco, radio global de `20.0px`.
- **Interacción:** Efectos sutiles al presionar para dar feedback visual.

---

## ✨ 5. Principios de Diseño

1.  **Minimalismo Moderno (Pinterest-inspired):** Interfaces centradas, uso de tarjetas (`Cards`) con bordes muy suaves y amplios espacios negativos.
2.  **Solidez:** Se prefieren colores sólidos y planos para una lectura rápida y eficiente.
3.  **Elevación Sutil:** Las sombras deben ser casi imperceptibles, priorizando la estructura física del contenido.
4.  **Consistencia:** Respeto absoluto a la **Regla de Oro de UI** (Cero valores hardcodeados).
