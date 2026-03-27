import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import '../providers/summer_course_token_provider.dart';
import '../providers/active_registration_provider.dart';
import '../views/summer_course_active_registration_modal.dart';

class SummerCourseAccessCard extends ConsumerWidget {
  const SummerCourseAccessCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(summerCourseTokenProvider);
    final activeRegAsync = ref.watch(activeRegistrationProvider);

    return tokenAsync.when(
      data: (tokenData) {
        if (tokenData == null) return const SizedBox.shrink();

        final token = tokenData['token'] as String?;
        if (token == null) return const SizedBox.shrink();

        // Check if there is an active registration
        return activeRegAsync.when(
          data: (regData) {
            final hasRegistration = regData?['has_registration'] == true;
            if (!hasRegistration) return const SizedBox.shrink();

            final participantsCount = regData?['participants_count'] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF335B9B), // Azul vibrante un poco más oscuro
                Color(0xFF1E3A68), // Azul noche
                Color(0xFF132A52), // Azul profundo
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF132A52).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showFullCode(context, token),
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                   // Marca de agua y adornos "creativos" en el fondo de la tarjeta
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 160,
                      color: AppTheme.neutral50.withOpacity(0.04), // Sin blancos puros
                    ),
                  ),
                  Positioned(
                    left: -60,
                    bottom: -60,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Hero(
                      tag: 'summer-course-qr-hero',
                      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                        return DefaultTextStyle(
                          style: DefaultTextStyle.of(toHeroContext).style,
                          child: toHeroContext.widget,
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor, // En lugar de Colors.white (blanco puro)
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: token,
                            version: QrVersions.auto,
                            size: 48.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppTheme.neutral800, // En lugar de Colors.black (negro puro)
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: AppTheme.neutral900, // En lugar de negro puro
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MI ACCESO NETKEY',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Curso de Verano 2026',
                            style: TextStyle(
                              color: AppTheme.neutral50, // En lugar de Colors.white
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.neutral50.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.neutral50.withOpacity(0.12)),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                token,
                                style: const TextStyle(
                                  color: AppTheme.vibrantGold,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.neutral100.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppTheme.neutral100.withOpacity(0.08)),
                                ),
                                child: Text(
                                  '$participantsCount Alumnos',
                                  style: TextStyle(
                                    color: AppTheme.neutral100.withOpacity(0.85),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => SummerCourseActiveRegistrationModal(registrationData: regData!),
                                    );
                                  },
                                  icon: const Icon(Icons.settings_rounded, color: AppTheme.primaryColor, size: 16),
                                  label: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Gestionar',
                                      style: TextStyle(
                                        color: AppTheme.neutral50,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    backgroundColor: AppTheme.neutral100.withOpacity(0.06),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.35)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showFullCode(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Hero(
              tag: 'summer-course-qr-hero',
              flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                return DefaultTextStyle(
                  style: DefaultTextStyle.of(toHeroContext).style,
                  child: toHeroContext.widget,
                );
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor, // En lugar de Colors.white
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neutral900.withOpacity(0.15), // En lugar de Colors.black
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImageView(
                        data: token,
                        version: QrVersions.auto,
                        size: 220.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppTheme.neutral900,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppTheme.neutral900,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'TOKEN MAESTRO',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: AppTheme.neutral500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        token,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Presenta este código QR o Token al instructor para recoger a tus hijos de forma segura.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.neutral500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close_rounded, color: AppTheme.surfaceColor, size: 24), // No pure white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

