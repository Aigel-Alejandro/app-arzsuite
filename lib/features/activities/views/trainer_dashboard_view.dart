import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/responsive_grid.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/widgets/premium_horizontal_calendar.dart';
import 'package:app_arzsuite/features/activities/views/trainer_attendance_view.dart';
import 'package:app_arzsuite/features/activities/views/trainer_evaluation_view.dart';

class TrainerDashboardView extends StatelessWidget {
  const TrainerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 1,
      child: Scaffold(
        backgroundColor: AppTheme.neutral50,
        appBar: AppBar(
          title: const Text('Mi Panel Docente', style: TextStyle(fontWeight: FontWeight.w900)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.neutral900,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingMedium),
                
                // Header (Sin animaciones)
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'Hola, Coach',
                           style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                 color: AppTheme.neutral500,
                               ),
                         ),
                         Text(
                           'Carlos Ramírez',
                           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                 fontWeight: FontWeight.w900,
                                 color: AppTheme.primaryColor,
                               ),
                         ),
                       ],
                     ),
                     CircleAvatar(
                       radius: 28,
                       backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                       child: const Icon(Icons.sports_rounded, color: AppTheme.primaryColor, size: 28),
                     )
                   ],
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                
                // Interactive Calendar
                Text(
                   'Mi Calendario',
                   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                PremiumHorizontalCalendar(onDateSelected: (day) {}),
                
                const SizedBox(height: AppTheme.spacingLarge),
                
                Text(
                  'Accesos Rápidos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.neutral900,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                
                ResponsiveGrid(
                  children: [
                    _TrainerActionCardPremium(
                      title: 'Pase de Lista',
                      subtitle: 'Fútbol Infantil (Sub-12)',
                      icon: Icons.checklist_rtl_rounded,
                      color: AppTheme.primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(pageBuilder: (_, __, ___) => const TrainerAttendanceView(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero),
                        );
                      },
                    ),
                    _TrainerActionCardPremium(
                      title: 'Evaluaciones',
                      subtitle: 'Fútbol Infantil (Sub-12)',
                      icon: Icons.star_rate_rounded,
                      color: AppTheme.vibrantGold,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(pageBuilder: (_, __, ___) => const TrainerEvaluationView(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingLarge),
                Text(
                  'Partidos de Hoy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.neutral900,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                
                _MatchAdminCardPremium(
                  title: 'Jornada 5 vs Club X',
                  time: '10:00 AM',
                  location: 'Cancha Central',
                ),
                Builder(
                  builder: (context) {
                    final bool isMobile = MediaQuery.of(context).size.width < AppTheme.breakpointTablet;
                    return SizedBox(height: isMobile ? 120 : 48);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainerActionCardPremium extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TrainerActionCardPremium({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_TrainerActionCardPremium> createState() => _TrainerActionCardPremiumState();
}

class _TrainerActionCardPremiumState extends State<_TrainerActionCardPremium> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _isHovered ? 1.02 : 1.0,
      child: InkWell(
        onHover: (v) => setState(() => _isHovered = v),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
            border: Border.all(color: widget.color.withValues(alpha: _isHovered ? 0.3 : 0.05), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _isHovered ? 0.15 : 0.03),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              )
            ],
          ),
          child: Row(
            children: [
               Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
                child: Icon(widget.icon, color: widget.color, size: 28),
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900)),
                    const SizedBox(height: 4),
                    Text(widget.subtitle, style: const TextStyle(color: AppTheme.neutral500, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: widget.color.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchAdminCardPremium extends StatelessWidget {
  final String title;
  final String time;
  final String location;

  const _MatchAdminCardPremium({required this.title, required this.time, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
            child: Column(
              children: [
                const Text('HOY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
             onPressed: () {
                // Abre el modal para actualizar el marcador / sede
                // Oculto por simplicidad
             },
             icon: const Icon(Icons.edit_rounded, color: Colors.white),
          )
        ],
      ),
    );
  }
}
