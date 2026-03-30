import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';

import 'package:app_arzsuite/features/summer_course/views/summer_course_wizard_view.dart';
import 'package:app_arzsuite/features/activities/views/activities_dashboard_view.dart';
import 'package:app_arzsuite/features/summer_course/widgets/access_card.dart';
import 'package:app_arzsuite/features/summer_course/views/summer_course_scanner_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/features/activities/providers/family_agenda_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sticky/Fixed Integrated Header
          Container(
            padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, 32, AppTheme.spacingLarge, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Matches scaffold to blend seamlessly
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // Vertically centered like typical headers
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Keep column compact
                    children: [
                      Text(
                        'Buen día,',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '¡Bienvenido!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ResponsiveContainer(
                padding: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                      child: SummerCourseAccessCard(),
                    ),
                    // Hero: Summer Course 2026
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACCESOS DE STAFF / VERANO',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _CompactActionCard(
                                title: 'Inscripción',
                                subtitle: 'Cursos 2026',
                                icon: Icons.sunny,
                                color: AppTheme.primaryColor,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const SummerCourseWizardView()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _CompactActionCard(
                                title: 'Escáner QR',
                                subtitle: 'Control Staff',
                                icon: Icons.qr_code_scanner_rounded,
                                color: const Color(0xFFE65100), // Naranja oscuro para destacar
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const SummerCourseScannerView()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'MINI-AGENDA SEMANAL',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 16),
                        const _AgendaWidget(),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 48),
                
                // Bottom Logo or Branding
                Center(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/logo-centro-libanes.png',
                      height: 50,
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final bool isMobile = MediaQuery.of(context).size.width < AppTheme.breakpointTablet;
                    return SizedBox(height: isMobile ? 120 : 32);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
      ],
      ),
    );
  }
}

class _CompactActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CompactActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppTheme.neutral800 : AppTheme.neutral200.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        letterSpacing: -0.3,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AgendaWidget extends ConsumerWidget {
  const _AgendaWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaAsync = ref.watch(familyAgendaProvider);

    return agendaAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No hay eventos programados en tu familia.',
                style: TextStyle(color: AppTheme.neutral500, fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        return Column(
          children: items.map((item) {
            final color = _parseColor(item.colorHex);
            final icon = _parseIcon(item.icon);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAgendaItem(
                context: context,
                time: item.timeBlock,
                duration: item.durationStr,
                title: item.title,
                subtitle: item.subtitle,
                person: item.personName,
                icon: icon,
                color: color,
                isMatch: item.isMatch,
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
      error: (e, st) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text('Error cargando agenda', style: TextStyle(color: AppTheme.dangerColor)),
        ),
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppTheme.primaryColor;
    try {
      String formattedHex = hex.replaceAll('#', '');
      if (formattedHex.length == 6) {
        formattedHex = 'FF$formattedHex';
      }
      return Color(int.parse(formattedHex, radix: 16));
    } catch (_) {
      return AppTheme.primaryColor;
    }
  }

  IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case 'pool_rounded':
      case 'pool':
        return Icons.pool_rounded;
      case 'sports_soccer_rounded':
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'sports_tennis_rounded':
      case 'sports_tennis':
        return Icons.sports_tennis_rounded;
      case 'sports_basketball_rounded':
      case 'sports_basketball':
        return Icons.sports_basketball_rounded;
      case 'fitness_center_rounded':
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'self_improvement_rounded':
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Widget _buildAgendaItem({
    required BuildContext context,
    required String time,
    required String duration,
    required String title,
    required String subtitle,
    required String person,
    required IconData icon,
    required Color color,
    bool isMatch = false,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.neutral900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.neutral800 : AppTheme.neutral200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time Sidebar
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppTheme.neutral900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$duration hrs',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppTheme.neutral500),
                  ),
                ],
              ),
            ),
            // Divider
            Container(width: 4, color: color),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(icon, size: 16, color: color),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              height: 1.2,
                              color: isDark ? Colors.white : AppTheme.neutral900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: AppTheme.neutral500),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.neutral100,
                          child: const Icon(Icons.person, size: 14, color: AppTheme.neutral500),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            person,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.2, color: isDark ? AppTheme.neutral300 : AppTheme.neutral700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isMatch) const SizedBox(width: 8),
                        if (isMatch)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('OFICIAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.redAccent, letterSpacing: 0.5)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


