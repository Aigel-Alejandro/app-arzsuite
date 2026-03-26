import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import '../providers/summer_course_token_provider.dart';

class SummerCourseAccessCard extends ConsumerWidget {
  const SummerCourseAccessCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(summerCourseTokenProvider);

    return tokenAsync.when(
      data: (data) {
        if (data == null) return const SizedBox.shrink();

        final token = data['token'] as String?;
        if (token == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.secondaryColor, AppTheme.secondaryColor.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryColor.withOpacity(0.3),
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MI ACCESO NETKEY',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Curso de Verano 2026',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.vibrantGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              token,
                              style: const TextStyle(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showFullCode(BuildContext context, String token) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Presenta este código al instructor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Servirá para recoger a todos tus hijos e invitados de forma segura.',
              style: TextStyle(color: AppTheme.neutral500),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.neutral50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.neutral200),
              ),
              child: Column(
                children: [
                   // In a real app, I'd generate a real QR here.
                   const Icon(Icons.qr_code_2_rounded, size: 200, color: AppTheme.secondaryColor),
                   const SizedBox(height: 24),
                   Text(
                     token,
                     style: const TextStyle(
                       fontSize: 42, 
                       fontWeight: FontWeight.w900, 
                       letterSpacing: 10,
                       color: AppTheme.secondaryColor
                     ),
                   ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('CERRAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
