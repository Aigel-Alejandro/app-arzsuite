import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../models/inscripcion_model.dart';
import '../providers/mis_inscripciones_provider.dart';
import '../../../core/widgets/toast_alerts.dart';

class MisReservasView extends ConsumerStatefulWidget {
  const MisReservasView({super.key});

  @override
  ConsumerState<MisReservasView> createState() => _MisReservasViewState();
}

class _MisReservasViewState extends ConsumerState<MisReservasView> {
  @override
  Widget build(BuildContext context) {
    final asyncInscripciones = ref.watch(misInscripcionesProvider);

    return Scaffold(
      backgroundColor: AppTheme.neutral50,
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.neutral900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualizar',
            onPressed: () =>
                ref.read(misInscripcionesProvider.notifier).fetch(),
          ),
        ],
      ),
      body: asyncInscripciones.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(e.toString()),
        data: (items) => items.isEmpty
            ? _buildEmpty()
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(misInscripcionesProvider.notifier).fetch(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppTheme.spacingSmall),
                  itemBuilder: (context, i) =>
                      _InscripcionCard(inscripcion: items[i]),
                ),
              ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 64,
            color: AppTheme.neutral300,
          ),
          const SizedBox(height: 16),
          Text(
            'Sin reservas activas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.neutral600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inscríbete en una actividad para ver\ntus reservas aquí.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.neutral400),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppTheme.dangerColor,
            ),
            const SizedBox(height: 12),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card de inscripción ──────────────────────────────────────────────────────
class _InscripcionCard extends ConsumerStatefulWidget {
  final InscripcionModel inscripcion;
  const _InscripcionCard({required this.inscripcion});

  @override
  ConsumerState<_InscripcionCard> createState() => _InscripcionCardState();
}

class _InscripcionCardState extends ConsumerState<_InscripcionCard> {
  bool _cancelling = false;

  Color get _accentColor {
    final hex = widget.inscripcion.actividadColor;
    if (hex == null) return AppTheme.primaryColor;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppTheme.primaryColor;
    }
  }

  Future<void> _cancelar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text(
          '¿Estás seguro que deseas cancelar tu lugar '
          '${widget.inscripcion.lugarAsiento != null ? "(${widget.inscripcion.lugarAsiento}) " : ""}'
          'en ${widget.inscripcion.actividadNombre}?\n\n'
          'Tu lugar quedará libre para otros socios.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, conservar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _cancelling = true);
    try {
      await ref
          .read(misInscripcionesProvider.notifier)
          .cancelar(widget.inscripcion.id);
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Reserva cancelada exitosamente');
      }
    } on DioException catch (e) {
      if (mounted) {
        String msg = e.message ?? e.toString();
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          msg = e.response!.data['message'];
        }
        ToastAlerts.showError(context, msg);
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ins = widget.inscripcion;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header colored bar ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    size: 20,
                    color: _accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ins.actividadNombre,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.neutral900,
                        ),
                      ),
                      if (ins.grupoNombre != null)
                        Text(
                          ins.grupoNombre!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.neutral500),
                        ),
                    ],
                  ),
                ),
                // Asiento badge
                if (ins.lugarAsiento != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ins.lugarAsiento!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Info pills ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ins.fechaClaseStr != null || ins.diaSemanaStr != null)
                  _infoRow(
                    Icons.calendar_today_rounded,
                    ins.fechaClaseStr ?? ins.diaSemanaStr ?? '',
                    _accentColor,
                  ),
                if (ins.horarioStr != null) ...[
                  const SizedBox(height: 6),
                  _infoRow(
                    Icons.schedule_rounded,
                    ins.horarioStr!,
                    _accentColor,
                  ),
                ],
                if (ins.lugar != null) ...[
                  const SizedBox(height: 6),
                  _infoRow(Icons.location_on_rounded, ins.lugar!, _accentColor),
                ],
              ],
            ),
          ),

          // ── Cancelar button ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _cancelling ? null : _cancelar,
                icon: _cancelling
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cancel_outlined, size: 16),
                label: Text(_cancelling ? 'Cancelando...' : 'Cancelar reserva'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.dangerColor,
                  side: const BorderSide(color: AppTheme.dangerColor),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
