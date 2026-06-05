import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_arzsuite/core/theme/app_theme.dart';

/// Sistema centralizado de Alertas (Toasts flotantes) para informar al usuario de manera elegante.
/// Documentación de uso:
/// - Usa `ToastAlerts.showSuccess` para operaciones que salieron bien (e.g. "Código enviado").
/// - Usa `ToastAlerts.showError` para errores críticos o validaciones negativas (e.g. "Credenciales incorrectas").
/// - Usa `ToastAlerts.showWarning` para precauciones o validaciones leves (e.g. "Ingresa el nombre primero").
class ToastAlerts {
  static OverlayEntry? _currentOverlay;
  static Timer? _timer;

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
    if (_currentOverlay != null && _currentOverlay!.mounted) {
      _currentOverlay?.remove();
    }
    _currentOverlay = null;
    _timer?.cancel();

    final overlayState = Overlay.of(context, rootOverlay: true);
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: _ToastWidget(
              message: message,
              icon: icon,
              color: color,
              isDark: isDark,
              onTap: () {
                onTap?.call();
                if (overlayEntry.mounted) {
                  overlayEntry.remove();
                }
                if (_currentOverlay == overlayEntry) {
                  _currentOverlay = null;
                }
                _timer?.cancel();
              },
            ),
          ),
        );
      },
    );

    _currentOverlay = overlayEntry;
    overlayState.insert(overlayEntry);

    _timer = Timer(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
      if (_currentOverlay == overlayEntry) {
        _currentOverlay = null;
      }
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: widget.color, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : AppTheme.neutral900,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    style: TextButton.styleFrom(
                      foregroundColor: widget.color,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(40, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
