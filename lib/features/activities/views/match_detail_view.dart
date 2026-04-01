import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/features/activities/models/match_model.dart';
import 'package:app_arzsuite/features/activities/providers/matches_provider.dart';

class MatchDetailView extends ConsumerStatefulWidget {
  final MatchModel match;

  const MatchDetailView({super.key, required this.match});

  @override
  ConsumerState<MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends ConsumerState<MatchDetailView> {
  bool _isLoading = false;

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
                       Text(widget.match.torneoNombre, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                       const SizedBox(height: AppTheme.spacingSmall),
                       Text(
                         '${widget.match.esLocal ? widget.match.equipoNuestro : widget.match.equipoRival} vs ${widget.match.esLocal ? widget.match.equipoRival : widget.match.equipoNuestro}',
                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: AppTheme.spacingMedium),
                       if (widget.match.estadoPartido == 'finalizado')
                         Container(
                           margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                           child: Text(
                             'Marcador: ${widget.match.esLocal ? widget.match.golesLocal : widget.match.golesVisitante} - ${widget.match.esLocal ? widget.match.golesVisitante : widget.match.golesLocal}', 
                             style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.primaryColor),
                           ),
                         ),
                       _InfoBadge(icon: Icons.calendar_month_rounded, text: _formatDateTime(widget.match.fecha)),
                       const SizedBox(height: 8),
                       _InfoBadge(icon: Icons.location_on_rounded, text: widget.match.lugar),
                     ],
                   ),
                 ),
                 
                 const SizedBox(height: AppTheme.spacingLarge),
                 Text(
                   'Tu Convocatoria',
                   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                 ),
                 const SizedBox(height: AppTheme.spacingMedium),
                 const Text('El profesor te ha convocado a este partido. Confirma tu asistencia lo antes posible.', style: TextStyle(color: AppTheme.neutral600)),
                 const SizedBox(height: AppTheme.spacingLarge),
                 
                 if (_isLoading)
                   const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                 else if (widget.match.estadoPartido == 'finalizado' || widget.match.estadoPartido == 'cancelado')
                   Center(
                     child: Text(
                       'El partido ha ${widget.match.estadoPartido}.',
                       style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.neutral600),
                     ),
                   )
                 else ...[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       _ResponseButton(
                         title: 'Confirmar',
                         icon: Icons.check_circle_rounded,
                         color: AppTheme.successColor,
                         isSelected: widget.match.estadoConfirmacion == 'confirmado',
                         onTap: () => _updateAsistencia('confirmado'),
                       ),
                       _ResponseButton(
                         title: 'No Asistirá',
                         icon: Icons.cancel_rounded,
                         color: AppTheme.dangerColor,
                         isSelected: widget.match.estadoConfirmacion == 'cancelado',
                         onTap: () => _updateAsistencia('cancelado'),
                       )
                     ],
                   ),
                 ],
                 
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

  String _formatDateTime(String isoStr) {
    try {
      final dt = DateTime.parse(isoStr);
      final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
      final m = dt.minute.toString().padLeft(2, '0');
      return '${days[dt.weekday - 1]} ${dt.day}, ${dt.hour}:$m hrs';
    } catch (_) {
      return isoStr;
    }
  }

  Future<void> _updateAsistencia(String estado) async {
    if (widget.match.estadoConfirmacion == estado) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(matchesProvider.notifier).confirmAssistance(widget.match.convocatoriaId, estado);
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Se ha guardado tu respuesta exitosamente.');
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
