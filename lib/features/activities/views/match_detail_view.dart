import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';

class MatchDetailView extends StatefulWidget {
  const MatchDetailView({super.key});

  @override
  State<MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends State<MatchDetailView> {
  // null = no contestado, true = confirmado, false = rechazado
  bool? _isConfirmed;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Detalle de Partido'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
           physics: const BouncingScrollPhysics(),
           child: ResponsiveContainer(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const SizedBox(height: AppTheme.spacingLarge),
                 Container(
                   width: double.infinity,
                   padding: const EdgeInsets.all(AppTheme.spacingLarge),
                   decoration: BoxDecoration(
                     color: AppTheme.primaryColor,
                     borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                   ),
                   child: Column(
                     children: [
                       const Text('Jornada 5', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                       const SizedBox(height: AppTheme.spacingSmall),
                       Text(
                         'Nosotros vs Club X',
                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: AppTheme.spacingMedium),
                       _InfoBadge(icon: Icons.calendar_month_rounded, text: 'Sábado 21, 10:00 AM'),
                       const SizedBox(height: 8),
                       _InfoBadge(icon: Icons.location_on_rounded, text: 'Cancha Central'),
                     ],
                   ),
                 ),
                 
                 const SizedBox(height: AppTheme.spacingLarge),
                 Text(
                   'Convocatoria: Juanito Pérez',
                   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                 ),
                 const SizedBox(height: AppTheme.spacingMedium),
                 const Text('El profesor te ha convocado a este partido. Confirma la asistencia de tu hijo/a lo antes posible.', style: TextStyle(color: AppTheme.neutral600)),
                 const SizedBox(height: AppTheme.spacingLarge),
                 
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     _ResponseButton(
                       title: 'Confirmar',
                       icon: Icons.check_circle_rounded,
                       color: AppTheme.successColor,
                       isSelected: _isConfirmed == true,
                       onTap: () {
                         setState(() => _isConfirmed = true);
                         ToastAlerts.showSuccess(context, 'Notificado: Asistencia Confirmada');
                       },
                     ),
                     _ResponseButton(
                       title: 'No Asistirá',
                       icon: Icons.cancel_rounded,
                       color: AppTheme.dangerColor,
                       isSelected: _isConfirmed == false,
                       onTap: () {
                         setState(() => _isConfirmed = false);
                         ToastAlerts.showSuccess(context, 'Notificado: Asistencia Rechazada');
                       },
                     )
                   ],
                 ),
                 
                 const SizedBox(height: AppTheme.spacingLarge),
                 const Divider(height: 32, color: AppTheme.neutral100),
                 ListTile(
                    leading: const Icon(Icons.map_rounded, color: AppTheme.primaryColor),
                    title: const Text('Abrir en Waze / Maps', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {},
                  ),
                ],
              ),
            ),
         ),
       ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ResponseButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResponseButton({required this.title, required this.icon, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          border: Border.all(color: isSelected ? color : AppTheme.neutral100, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : AppTheme.neutral400, size: 32),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? color : AppTheme.neutral600)),
          ],
        ),
      ),
    );
  }
}
