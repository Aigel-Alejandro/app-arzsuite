import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';

import 'package:app_arzsuite/features/summer_course/views/summer_course_wizard_view.dart';
import 'package:app_arzsuite/features/summer_course/widgets/access_card.dart';
import 'package:app_arzsuite/features/summer_course/views/summer_course_scanner_view.dart';
import 'package:app_arzsuite/features/summer_course/providers/active_course_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_arzsuite/features/activities/providers/family_agenda_provider.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';
import 'package:app_arzsuite/features/activities/models/family_agenda_item.dart';
import 'package:app_arzsuite/features/tournaments/views/tournaments_dashboard_view.dart';
import 'package:app_arzsuite/features/tournaments/providers/tournaments_provider.dart';
import 'package:app_arzsuite/features/tournaments/widgets/premium_tournament_card.dart';
import 'package:app_arzsuite/features/tournaments/views/tournament_my_detail_view.dart';

import 'package:app_arzsuite/core/providers/auth_provider.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/features/profile/providers/profile_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMember = ref.watch(authProvider);

    final profileAsync = ref.watch(profileProvider);

    String firstName = '';
    String fullNameToParse = '';

    // Intentamos obtener el nombre del perfil (más preciso) o del authProvider
    profileAsync.whenData((profile) {
      if (profile != null) {
        fullNameToParse = profile.firstName?.isNotEmpty == true 
            ? profile.firstName! 
            : profile.fullname;
      }
    });

    if (fullNameToParse.isEmpty && currentMember != null && currentMember.firstName.isNotEmpty) {
      fullNameToParse = currentMember.firstName;
    }

    if (fullNameToParse.isNotEmpty) {
      final parts = fullNameToParse.trim().split(' ');
      
      // Remover números iniciales (ej. número de membresía)
      while (parts.isNotEmpty && int.tryParse(parts.first) != null) {
        parts.removeAt(0);
      }
      
      if (parts.isNotEmpty) {
        firstName = parts.first;
        if (firstName.toLowerCase() == 'socio' && parts.length > 1) {
            firstName = parts[1]; // Saltar la palabra 'Socio'
        }
        if (firstName.length > 1) {
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
                        firstName.isNotEmpty ? 'Hola $firstName' : 'Hola',
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
                        // TODO: Cambiar a true para volver a mostrar torneos
                        const bool isTournamentsEnabled = false;
                        final hasTournaments  = (currentMember?.hasPermission('tournaments.dashboard') ?? false) && isTournamentsEnabled;
                        final hasSummerEnroll = (currentMember?.hasPermission('summer_course.enroll') ?? false) || (currentMember?.hasPermission('manage_family') ?? false);
                        if (!hasTournaments && !hasSummerEnroll && !isStaffOrInstructor) return const SizedBox.shrink();

                        final activeCourseAsync = ref.watch(activeSummerCourseProvider);

                        return activeCourseAsync.when(
                          data: (courseData) {
                            // TODO: Cambiar a true para volver a mostrar el curso de verano
                            const bool isSummerCourseEnabled = false;
                            final hasActiveCourse = courseData?['has_active_course'] == true;
                            final showSummer = hasActiveCourse && hasSummerEnroll && isSummerCourseEnabled;
                            final showQRScanner = hasActiveCourse && isStaffOrInstructor && isSummerCourseEnabled;
                            
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
                          
                          // TODO: Cambiar a true el flag (&& false) de esta línea para volver a mostrar Mis Torneos
                          if ((currentMember?.hasPermission('dashboard.tournaments') ?? false) && false) ...[
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
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _cancelar(BuildContext context, int id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text('¿Estás seguro que deseas cancelar tu lugar en "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Sí, cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final apiClient = ref.read(apiClientNotifierProvider);
        final res = await apiClient.dio.post('arzsuite/actividades/cancelar-inscripcion', data: {'inscripcion_id': id});
        if (res.data['success'] == true) {
          ref.refresh(familyAgendaProvider);
          if (mounted) {
            ToastAlerts.showSuccess(context, 'Reserva cancelada exitosamente');
          }
        }
      } on DioException catch (e) {
        if (mounted) {
          String serverError = 'Error desconocido';
          if (e.response?.data is Map && e.response?.data['message'] != null) {
            serverError = e.response!.data['message'];
          } else {
            serverError = e.message ?? e.toString();
          }
          ToastAlerts.showError(context, serverError);
        }
      } catch (e) {
        if (mounted) {
          ToastAlerts.showError(context, 'Error al cancelar: $e');
        }
      }
    }
  }

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
                'No hay actividades inscritas.',
                style: TextStyle(color: AppTheme.neutral500, fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        final canManageFamily = (currentMember?.isTitular ?? false) || (currentMember?.hasPermission('manage_family') ?? false);
        final canViewFamilyAgenda = canManageFamily || (currentMember?.hasPermission('dashboard.agenda.view_all') ?? false);
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
        if (!canViewFamilyAgenda) {
          // If not manager, force ONLY own items
          filteredItems = items.where((i) => i.socioId == myId).toList();
        } else {
          // Manager filtering
          if (_selectedSocioId == 'ME') {
             filteredItems = items.where((i) => i.socioId == myId).toList();
          } else if (_selectedSocioId != 'ALL') {
             filteredItems = items.where((i) => i.socioId == _selectedSocioId).toList();
          }
        }

        final today = DateTime.now();
        final startOfToday = DateTime(today.year, today.month, today.day);
        
        // Find Monday of this week
        final startOfThisWeek = startOfToday.subtract(Duration(days: startOfToday.weekday - 1));

        // Generate 8 weeks
        final weeks = List.generate(8, (i) => startOfThisWeek.add(Duration(days: i * 7)));

        // Determine active date (we will store the start of the week in _selectedDate instead of a specific day)
        DateTime activeWeekStart = _selectedDate ?? startOfThisWeek;
        // make sure activeWeekStart is a Monday
        activeWeekStart = activeWeekStart.subtract(Duration(days: activeWeekStart.weekday - 1));
        
        final activeWeekEnd = activeWeekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

        // Filter by active week
        filteredItems = filteredItems.where((item) {
          final eventDate = DateTime.fromMillisecondsSinceEpoch(item.timestamp * 1000);
          return eventDate.isAfter(activeWeekStart.subtract(const Duration(seconds: 1))) && 
                 eventDate.isBefore(activeWeekEnd.add(const Duration(seconds: 1)));
        }).toList();

        // Sort items by timestamp ascending
        filteredItems.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        
        final List<Widget> agendaWidgets = [];
        String lastDateStr = '';
        final monthsEsShort = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        final daysEs = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

        agendaWidgets.add(
          SizedBox(
            height: 56, // slightly higher for shadows
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weeks.length,
              itemBuilder: (context, index) {
                final weekStart = weeks[index];
                final weekEnd = weekStart.add(const Duration(days: 6));
                final isSelected = isSameDay(weekStart, activeWeekStart);
                
                String label;
                if (index == 0) {
                  label = 'Esta semana';
                } else if (index == 1) {
                  label = 'Próxima semana';
                } else {
                  label = '${weekStart.day} ${monthsEsShort[weekStart.month - 1]} - ${weekEnd.day} ${monthsEsShort[weekEnd.month - 1]}';
                }

                Widget content;
                if (index == 0) {
                  content = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month_rounded, size: 16, color: isSelected ? Colors.white : Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          letterSpacing: isSelected ? 0.3 : 0,
                        ),
                      ),
                    ],
                  );
                } else {
                  content = Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      letterSpacing: isSelected ? 0.3 : 0,
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = weekStart;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey.shade200,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                    ),
                    child: content,
                  ),
                );
              },
            ),
          ),
        );
        agendaWidgets.add(const SizedBox(height: 24));

        // Filter chips (Only for Manager or people with permission, and if there is more than 1 member active in agenda)
        if (canViewFamilyAgenda && membersMap.length > 1) {
          agendaWidgets.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppTheme.neutral900 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.neutral800 : AppTheme.neutral200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSocioId,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryColor),
                  dropdownColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.neutral900 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.neutral800,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'ME',
                      child: Text('Mis Actividades'),
                    ),
                    const DropdownMenuItem(
                      value: 'ALL',
                      child: Text('Todos los familiares'),
                    ),
                    ...membersMap.entries.where((e) => e.key != myId).map((entry) {
                      final n = entry.value.split(' ').first;
                      final capitalized = n.isEmpty ? n : n[0].toUpperCase() + n.substring(1).toLowerCase();
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text('Actividades de $capitalized'),
                      );
                    }),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedSocioId = val;
                      });
                    }
                  },
                ),
              ),
            ),
          );
          agendaWidgets.add(const SizedBox(height: 16));
        }

        if (filteredItems.isEmpty) {
          agendaWidgets.add(
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppTheme.neutral900 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.neutral800 : Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.event_busy_rounded, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Semana Libre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No tienes actividades programadas para estos días.', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500, 
                      fontSize: 13
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          for (var item in filteredItems) {
            final eventDate = DateTime.fromMillisecondsSinceEpoch(item.timestamp * 1000);
            final eventStartOfDay = DateTime(eventDate.year, eventDate.month, eventDate.day);
            
            String dateStr;
            if (eventStartOfDay == startOfToday) {
              dateStr = 'Hoy';
            } else if (eventStartOfDay == startOfToday.add(const Duration(days: 1))) {
              dateStr = 'Mañana';
            } else {
              dateStr = '${daysEs[eventDate.weekday - 1]}, ${eventDate.day} de ${monthsEsShort[eventDate.month - 1]}';
            }

            if (dateStr != lastDateStr) {
              agendaWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                  child: Text(
                    dateStr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.neutral600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              );
              lastDateStr = dateStr;
            }

            final color = _parseColor(item.colorHex);
            final icon = _parseIcon(item.icon);

            agendaWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAgendaItem(
                  context: context,
                  time: item.timeBlock,
                  duration: item.durationStr,
                  title: item.title,
                  subtitle: item.lugarSeleccionado != null && item.lugarSeleccionado!.isNotEmpty 
                      ? '${item.subtitle}: ${item.lugarSeleccionado}' 
                      : item.subtitle,
                  person: canManageFamily && _selectedSocioId == 'ALL' ? item.personName : '', 
                  icon: icon,
                  color: color,
                  isMatch: item.isMatch,
                  onCancel: !item.isMatch ? () => _cancelar(context, item.id, item.title) : null,
                ),
              ),
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: agendaWidgets,
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
    VoidCallback? onCancel,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.neutral900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: isDark ? AppTheme.neutral800 : color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : AppTheme.neutral900,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              if (isMatch)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('OFICIAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.redAccent, letterSpacing: 0.5)),
                                ),
                            ],
                          ),
                        ),
                        if (onCancel != null)
                          GestureDetector(
                            onTap: onCancel,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                              child: Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 22),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 14, color: AppTheme.neutral400),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: TextStyle(fontSize: 13, color: AppTheme.neutral500, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bottom section with time and person
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.neutral800 : AppTheme.neutral50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Time
                Icon(Icons.access_time_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Text(
                    time.replaceAll('\n', ' • ') + ' ($duration hrs)', 
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: isDark ? Colors.white : AppTheme.neutral800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Person
                if (person.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Text(
                      person,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.neutral600),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppTheme.neutral200,
                    child: const Icon(Icons.person, size: 14, color: AppTheme.neutral600),
                  ),
                ],
              ],
            ),
          ),
        ],
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
