import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';

import 'package:app_arzsuite/features/summer_course/views/summer_course_wizard_view.dart';
import 'package:app_arzsuite/features/summer_course/widgets/access_card.dart';
import 'package:app_arzsuite/features/summer_course/views/summer_course_scanner_view.dart';
import 'package:app_arzsuite/features/summer_course/providers/active_course_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_arzsuite/features/activities/providers/family_agenda_provider.dart';
import 'package:app_arzsuite/features/activities/models/family_agenda_item.dart';
import 'package:app_arzsuite/features/tournaments/views/tournaments_dashboard_view.dart';
import 'package:app_arzsuite/features/tournaments/providers/tournaments_provider.dart';
import 'package:app_arzsuite/features/tournaments/widgets/premium_tournament_card.dart';
import 'package:app_arzsuite/features/tournaments/views/tournament_my_detail_view.dart';

import 'package:app_arzsuite/core/providers/auth_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMember = ref.watch(authProvider);

    String firstName = '';
    if (currentMember != null && currentMember.firstName.isNotEmpty) {
      final parts = currentMember.firstName.trim().split(' ');
      if (parts.isNotEmpty) {
        firstName = parts.first;
        if (int.tryParse(firstName) != null) {
           firstName = '';
        } else if (firstName.length > 1) {
          firstName = firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
        }
      }
    }

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
                        firstName.isNotEmpty ? 'Buen día $firstName' : 'Buen día',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ],
                  ),
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
                    // ── Accesos Rápidos (verano + torneos unificados) ─────────
                    Consumer(
                      builder: (context, ref, _) {
                        final isStaffOrInstructor = currentMember?.memberType == 'staff' || currentMember?.memberType == 'instructor' || currentMember?.memberType == 'profesor';
                        final hasTournaments  = currentMember?.hasPermission('tournaments.dashboard') ?? false;
                        final hasSummerEnroll = currentMember?.hasPermission('summer_course.enroll') ?? false;
                        if (!hasTournaments && !hasSummerEnroll && !isStaffOrInstructor) return const SizedBox.shrink();

                        final activeCourseAsync = ref.watch(activeSummerCourseProvider);

                        return activeCourseAsync.when(
                          data: (courseData) {
                            final hasActiveCourse = courseData?['has_active_course'] == true;
                            final showSummer = hasActiveCourse && hasSummerEnroll;
                            final showQRScanner = hasActiveCourse && isStaffOrInstructor;
                            
                            if (!showSummer && !hasTournaments && !showQRScanner) return const SizedBox.shrink();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showSummer)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                                    child: SummerCourseAccessCard(),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ACCESOS RÁPIDOS',
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 2,
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          // Izquierda: Inscripción > Torneos > vacío
                                          if (showSummer)
                                            Expanded(
                                              child: _CompactActionCard(
                                                title: 'Inscripción',
                                                subtitle: courseData?['course']?['name'] ?? 'Curso de Verano',
                                                icon: Icons.sunny,
                                                color: AppTheme.primaryColor,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => const SummerCourseWizardView(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          else if (hasTournaments)
                                            Expanded(
                                              child: _CompactActionCard(
                                                title: 'Torneos',
                                                subtitle: 'Competencias',
                                                icon: Icons.emoji_events,
                                                color: Colors.deepPurple,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => const TournamentsDashboardView(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          const SizedBox(width: 16),
                                          // Derecha: Torneos (cuando ambos activos) o vacío
                                          if (showSummer && hasTournaments)
                                            Expanded(
                                              child: _CompactActionCard(
                                                title: 'Torneos',
                                                subtitle: 'Competencias',
                                                icon: Icons.emoji_events,
                                                color: Colors.deepPurple,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => const TournamentsDashboardView(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          else
                                            const Expanded(child: SizedBox.shrink()),
                                        ],
                                      ),
                                      if (showQRScanner) ...[
                                        const SizedBox(height: 24),
                                        Text(
                                          'STAFF VERANO',
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                color: const Color(0xFFE65100),
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2,
                                              ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _CompactActionCard(
                                                title: 'Escáner QR',
                                                subtitle: 'Control Staff',
                                                icon: Icons.qr_code_scanner_rounded,
                                                color: const Color(0xFFE65100),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => const SummerCourseScannerView(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            const Spacer(),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () {
                            if (!hasTournaments) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ACCESOS RÁPIDOS',
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
                                          title: 'Torneos',
                                          subtitle: 'Competencias',
                                          icon: Icons.emoji_events,
                                          color: Colors.deepPurple,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => const TournamentsDashboardView(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                       const SizedBox(width: 16),
                                       const Expanded(child: SizedBox.shrink()),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          error: (_, __) {
                            if (!hasTournaments) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ACCESOS RÁPIDOS',
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
                                          title: 'Torneos',
                                          subtitle: 'Competencias',
                                          icon: Icons.emoji_events,
                                          color: Colors.deepPurple,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => const TournamentsDashboardView(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                       const SizedBox(width: 16),
                                       const Expanded(child: SizedBox.shrink()),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          if (currentMember?.hasPermission('dashboard.agenda') ?? false) ...[
                            const SizedBox(height: 32),
                            Text(
                              'AGENDA DEPORTIVA',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _AgendaWidget(currentMember: currentMember),
                          ],
                          
                          if (currentMember?.hasPermission('dashboard.tournaments') ?? false) ...[
                            const SizedBox(height: 32),
                            Text(
                              'MIS TORNEOS',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            const _TournamentsListWidget(),
                          ],
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

class _AgendaWidget extends ConsumerStatefulWidget {
  final currentMember;
  const _AgendaWidget({this.currentMember});

  @override
  ConsumerState<_AgendaWidget> createState() => _AgendaWidgetState();
}

class _AgendaWidgetState extends ConsumerState<_AgendaWidget> {
  String _selectedSocioId = 'ME'; // 'ME', 'ALL', or a specific socioId

  @override
  Widget build(BuildContext context) {
    final agendaAsync = ref.watch(familyAgendaProvider);
    final currentMember = widget.currentMember;

    return agendaAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No hay eventos programados.',
                style: TextStyle(color: AppTheme.neutral500, fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        final isTitular = currentMember?.isTitular ?? false;
        final myId = currentMember?.id ?? '';

        // Extract unique members
        final Map<String, String> membersMap = {};
        for (var item in items) {
           if (item.personName.isNotEmpty && item.socioId.isNotEmpty) {
               membersMap[item.socioId] = item.personName;
           }
        }

        // Apply filtering
        List<FamilyAgendaItem> filteredItems = items;
        if (!isTitular) {
          // If not titular, force ONLY own items
          filteredItems = items.where((i) => i.socioId == myId).toList();
        } else {
          // Titular filtering
          if (_selectedSocioId == 'ME') {
             filteredItems = items.where((i) => i.socioId == myId).toList();
          } else if (_selectedSocioId != 'ALL') {
             filteredItems = items.where((i) => i.socioId == _selectedSocioId).toList();
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips (Only for Titular and if there is more than 1 member active in agenda)
            if (isTitular && membersMap.length > 1) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildPremiumChip('Mis Actividades', 'ME'),
                  _buildPremiumChip('Todos', 'ALL'),
                  ...membersMap.entries
                      .where((e) => e.key != myId)
                      .map((entry) { final n = entry.value.split(' ').first; final capitalized = n.isEmpty ? n : n[0].toUpperCase() + n.substring(1).toLowerCase(); return _buildPremiumChip(capitalized, entry.key); }),
                ],
              ),
              const SizedBox(height: 16),
            ],

            if (filteredItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No hay eventos para la selección.', 
                  style: TextStyle(color: AppTheme.neutral500, fontStyle: FontStyle.italic),
                ),
              )
            else
              ...filteredItems.map((item) {
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
                    person: isTitular && _selectedSocioId == 'ALL' ? item.personName : '', // Only show person name if viewing all
                    icon: icon,
                    color: color,
                    isMatch: item.isMatch,
                  ),
                );
              }),
          ],
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

  Widget _buildPremiumChip(String label, String id) {
    final isSelected = _selectedSocioId == id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          fontSize: 14,
          color: isSelected ? Colors.white : (isDark ? AppTheme.neutral300 : AppTheme.neutral700),
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: isDark ? AppTheme.neutral900 : Colors.white,
      selectedColor: AppTheme.primaryColor,
      side: BorderSide(
        color: isSelected ? AppTheme.primaryColor : (isDark ? AppTheme.neutral800 : AppTheme.neutral200),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      onSelected: (bool selected) {
        if (selected) setState(() => _selectedSocioId = id);
      },
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      height: 1.2,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  height: 1.2,
                                  color: isDark ? Colors.white : AppTheme.neutral900,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
                        if (person.isNotEmpty) ...[
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
                        ] else
                          const Spacer(),
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


class _TournamentsListWidget extends ConsumerWidget {
  const _TournamentsListWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsProvider);
    final currentMember = ref.watch(authProvider);
    
    return tournamentsAsync.when(
      data: (tournaments) {
        final inscribedTournaments = tournaments.where((t) => t.isUserInscribed).toList();

        if (inscribedTournaments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppTheme.spacingLarge),
            child: Center(
              child: Text(
                "Aún no estás inscrito en ningún torneo.",
                style: TextStyle(color: AppTheme.neutral500),
              ),
            ),
          );
        }

        return Column(
          children: [
            ...inscribedTournaments.map((tournament) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                child: PremiumTournamentCard(
                  tournament: tournament,
                  title: tournament.nombre,
                  activityName: tournament.actividadNombre ?? 'Disciplina general',
                  schedule: '${tournament.fechaInicio ?? 'Pronto'} al ${tournament.fechaFin ?? 'Por definir'}',
                  accentColor: Colors.deepPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TournamentMyDetailView(tournament: tournament)),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TournamentsDashboardView()),
                  );
                },
                icon: const Icon(Icons.emoji_events_rounded),
                label: const Text('Entrar al Catálogo Extendido', style: TextStyle(fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}
