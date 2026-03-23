import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';

/// Sistema centralizado de Alertas (Toasts flotantes) para informar al usuario de manera elegante.
/// Documentación de uso:
/// - Usa `ToastAlerts.showSuccess` para operaciones que salieron bien (e.g. "Código enviado").
/// - Usa `ToastAlerts.showError` para errores críticos o validaciones negativas (e.g. "Credenciales incorrectas").
/// - Usa `ToastAlerts.showWarning` para precauciones o validaciones leves (e.g. "Ingresa el nombre primero").
class ToastAlerts {
  static void showSuccess(BuildContext context, String message, {VoidCallback? onTap}) {
    _showToast(context, message, Icons.check_circle_rounded, AppTheme.successColor, onTap: onTap);
  }

  static void showError(BuildContext context, String message, {VoidCallback? onTap}) {
    _showToast(context, message, Icons.error_rounded, AppTheme.dangerColor, onTap: onTap);
  }

  static void showWarning(BuildContext context, String message, {VoidCallback? onTap}) {
    _showToast(context, message, Icons.warning_rounded, AppTheme.warningColor, onTap: onTap);
  }

  static void _showToast(BuildContext context, String message, IconData icon, Color color, {VoidCallback? onTap}) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    final snackBar = SnackBar(
      content: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isDark ? Colors.white : AppTheme.neutral900,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      // Fondo tipo "tarjeta" en vez de color sólido brillante para verse más elegante (tipo iOS Toast)
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40), // Flotante y elevado
      elevation: 10,
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'OK',
        textColor: color,
        onPressed: () {
          // El Snackbar se cerrará automáticamente
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
