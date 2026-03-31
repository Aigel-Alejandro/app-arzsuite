import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/tournaments/views/tournament_enrollment_view.dart';

class PremiumTournamentCard extends StatefulWidget {
  final dynamic tournament;
  final String title;
  final String activityName;
  final String schedule;
  final Color accentColor;
  final VoidCallback? onTap;

  const PremiumTournamentCard({
    super.key,
    required this.tournament,
    required this.title,
    required this.activityName,
    required this.schedule,
    required this.accentColor,
    this.onTap,
  });

  @override
  State<PremiumTournamentCard> createState() => _PremiumTournamentCardState();
}

class _PremiumTournamentCardState extends State<PremiumTournamentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
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
          onTap: widget.onTap ?? () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TournamentEnrollmentView(tournament: widget.tournament),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.emoji_events, color: widget.accentColor, size: 28),
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
                              const Icon(Icons.sports, size: 14, color: AppTheme.neutral500),
                              const SizedBox(width: 4),
                              Text(
                                widget.activityName,
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
                    _StatusChip(
                      label: widget.tournament.formato?.toUpperCase() ?? 'COMPETENCIA',
                      color: widget.accentColor,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FECHAS DE JUEGO',
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
        label,
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
