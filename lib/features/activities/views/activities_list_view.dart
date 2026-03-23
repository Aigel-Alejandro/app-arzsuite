import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/activity_subscription_view.dart';

class ActivitiesListView extends StatelessWidget {
  final bool isSubscribed;
  final bool useLayout;
  const ActivitiesListView({super.key, required this.isSubscribed, this.useLayout = true});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores institucionales según ux-ui.md (si no están en AppTheme)
    const Color institutionalBlue = Color(0xFF406EBA);
    
    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingLarge),
            
            // Header del listado (Premium look)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSubscribed ? 'Mis Inscripciones' : 'Catálogo de Actividades',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.neutral900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSubscribed 
                      ? 'Gestiona tus actividades y mantente al tanto de tus horarios.'
                      : 'Explora y únete a las diversas disciplinas que ofrecemos.',
                    style: TextStyle(color: AppTheme.neutral500, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLarge),
            
            _PremiumActivityCard(
              title: 'Fútbol Infantil (Sub-12)',
              instructor: 'Prof. Carlos Ramírez',
              schedule: 'Lun, Mié y Vie • 16:00 - 18:00',
              icon: Icons.sports_soccer_rounded,
              accentColor: institutionalBlue,
              spotsAvailable: isSubscribed ? null : 5,
              isSubscribed: isSubscribed,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            _PremiumActivityCard(
              title: 'Clase de Tenis',
              instructor: 'Prof. Ana López',
              schedule: 'Mar y Jue • 17:00 - 19:00',
              icon: Icons.sports_tennis_rounded,
              accentColor: AppTheme.vibrantGold,
              spotsAvailable: isSubscribed ? null : 0,
              isSubscribed: isSubscribed,
            ),
            
            // Espaciado inferior para evitar que el menú móvil cubra el contenido
            Builder(
              builder: (context) {
                final bool isMobile = MediaQuery.of(context).size.width < AppTheme.breakpointTablet;
                return SizedBox(height: isMobile ? 120 : 48);
              }
            ),
          ],
        ),
      ),
    );

    if (!useLayout) return content;

    return MainLayout(
      activeIndex: 1, 
      child: Scaffold(
        backgroundColor: AppTheme.neutral50,
        appBar: AppBar(
          title: Text(isSubscribed ? 'Mis Actividades' : 'Actividades Disponibles'),
          centerTitle: true,
        ),
        body: content,
      ),
    );
  }
}

class _PremiumActivityCard extends StatefulWidget {
  final String title;
  final String instructor;
  final String schedule;
  final IconData icon;
  final Color accentColor;
  final int? spotsAvailable;
  final bool isSubscribed;

  const _PremiumActivityCard({
    required this.title,
    required this.instructor,
    required this.schedule,
    required this.icon,
    required this.accentColor,
    this.spotsAvailable,
    required this.isSubscribed,
  });

  @override
  State<_PremiumActivityCard> createState() => _PremiumActivityCardState();
}

class _PremiumActivityCardState extends State<_PremiumActivityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isFull = widget.spotsAvailable == 0;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                ? widget.accentColor.withValues(alpha: 0.15) 
                : AppTheme.neutral900.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 25 : 15,
              offset: Offset(0, _isHovered ? 12 : 8),
            )
          ],
          border: Border.all(
            color: _isHovered ? widget.accentColor.withValues(alpha: 0.3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            if (!widget.isSubscribed && !isFull) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const ActivitySubscriptionView(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icono de Actividad
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(widget.icon, color: widget.accentColor, size: 28),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppTheme.neutral900,
                              fontSize: 18,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded, size: 14, color: AppTheme.neutral500),
                              const SizedBox(width: 4),
                              Text(
                                widget.instructor,
                                style: const TextStyle(
                                  color: AppTheme.neutral600, 
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Etiqueta de Estado
                    if (widget.isSubscribed)
                      _StatusChip(
                        label: 'Suscrito',
                        color: AppTheme.successColor,
                      )
                    else if (isFull)
                      _StatusChip(
                        label: 'Agotado',
                        color: AppTheme.dangerColor,
                      )
                    else
                      _StatusChip(
                        label: '${widget.spotsAvailable} Lugares',
                        color: AppTheme.primaryColor,
                      ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppTheme.spacingMedium),
                  child: Divider(color: AppTheme.neutral100, height: 1),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Horario
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HORARIO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.neutral400,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.schedule,
                            style: const TextStyle(
                              color: AppTheme.neutral700,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Botón de Acción
                    if (widget.isSubscribed)
                      ElevatedButton(
                        onPressed: () {}, // Ver chats/detalles
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.neutral900,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Ver Chats', 
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)
                        ),
                      )
                    else if (!isFull)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: widget.accentColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

