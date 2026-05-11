import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';
import 'package:dio/dio.dart' as dio;

import '../services/summer_course_service.dart';
import '../providers/active_registration_provider.dart';

class SummerCourseActiveRegistrationModal extends ConsumerStatefulWidget {
  final Map<String, dynamic> registrationData;

  const SummerCourseActiveRegistrationModal({
    super.key,
    required this.registrationData,
  });

  @override
  ConsumerState<SummerCourseActiveRegistrationModal> createState() =>
      _SummerCourseActiveRegistrationModalState();
}

class _SummerCourseActiveRegistrationModalState
    extends ConsumerState<SummerCourseActiveRegistrationModal> {
  bool _isLoadingActivities = true;
  List<Map<String, dynamic>> _intensiveActivities = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadIntensiveActivities();
  }

  Future<void> _loadIntensiveActivities() async {
    final service = ref.read(summerCourseServiceProvider);
    final activities = await service.getIntensiveActivities();
    if (mounted) {
      setState(() {
        _intensiveActivities = activities;
        _isLoadingActivities = false;
      });
    }
  }

  Future<void> _updateActivity(int participantId, int? newActivityId) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final service = ref.read(summerCourseServiceProvider);
      final success = await service.updateIntensiveActivity(
        participantId,
        newActivityId,
      );

      if (mounted) {
        if (success) {
          // Refresh the global active registration Provider to update UI instantly
          ref.invalidate(activeRegistrationProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Actividad actualizada correctamente'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Error al actualizar la actividad'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(
          context,
          'Ocurrió un error inesperado al actualizar la actividad.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showUpgradeActivitySelector(BuildContext context, int participantId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verano Intensivo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona la disciplina para generar tu pago con Karlo pay.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              ..._intensiveActivities.map((act) {
                final cost =
                    double.tryParse(act['extra_cost']?.toString() ?? '0') ?? 0;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.vibrantGold.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: AppTheme.vibrantGold,
                    ),
                  ),
                  title: Text(
                    act['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Costo adicional: \$${cost.toStringAsFixed(2)} MXN',
                    style: const TextStyle(
                      color: AppTheme.successColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.neutral400,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    final aId = int.tryParse(act['id']?.toString() ?? '0') ?? 0;
                    _requestUpgrade(
                      participantId,
                      aId,
                      (act['name'] ?? '').toString(),
                      cost,
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _requestUpgrade(
    int participantId,
    int activityId,
    String activityName,
    double cost,
  ) async {
    setState(() => _isSaving = true);

    // Mostramos un loader intermedio opcional o simplemente cargamos
    const loadingMessage = 'Generando línea de captura...';
    ToastAlerts.showSuccess(context, loadingMessage);

    try {
      final apiClient = ref.read(apiClientNotifierProvider);

      final response = await apiClient.dio.post(
        '/deportivo/summer-course/upgrade-specialty',
        data: {
          'participant_id': participantId,
          'intensive_activity_id': activityId,
          'amount': cost,
        },
      );

      if (response.statusCode == 200 && mounted) {
        String orderId = 'SO-UPG-UNKNOWN';
        bool isFree = false;
        
        if (response.data is Map && response.data['data'] is Map) {
          isFree = response.data['data']['free'] == true;
          orderId =
              response.data['data']['sales_order_id']?.toString() ?? orderId;
        } else {
          // Force a crash that will be caught by our UI to print the EXACT json payload from CakePHP
          throw Exception('Backend_Response_Was: ${response.data}');
        }

        // Recargar silenciosamente los datos para que el status "Pendiente" aparezca de inmediato
        ref.invalidate(activeRegistrationProvider);

        if (isFree) {
          ToastAlerts.showSuccess(context, 'Actividad asignada sin costo adicional.');
          return;
        }

        showDialog(
          context: context,
          builder: (dCtx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.successColor,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text('Orden Generada'),
              ],
            ),
            content: Text(
              'La línea de captura de Karlo pay ha sido creada:\n$orderId\n\n'
              'Una vez que proceses el pago (actualización manual en DB), el verano intensivo ($activityName) se reflejará automáticamente en tu perfil.',
              style: const TextStyle(height: 1.5, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dCtx,
                  ); // Mantiene el modal abierto. Se actualizará vía Riverpod.
                },
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } on dio.DioException catch (e) {
      if (mounted) {
        String msg = 'Error al conectar con Karlo pay.';
        if (e.response != null && e.response?.data != null) {
          msg = 'Error backend: ${e.response?.data}';
        }
        ToastAlerts.showError(context, msg);
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, 'Error inesperado: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeRegAsync = ref.watch(activeRegistrationProvider);
    final participants =
        activeRegAsync.value?['participants'] as List<dynamic>? ??
        widget.registrationData['participants'] as List<dynamic>? ??
        [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppTheme.neutral300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.snowboarding_rounded,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verano Intensivo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Edita el tipo de curso a tomar',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Acción manual de recargar (útil para pruebas de actualización de Base de Datos vía SQL)
                    ref.invalidate(activeRegistrationProvider);
                  },
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.neutral500,
                  ),
                  tooltip: 'Actualizar',
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.neutral100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppTheme.neutral600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(height: 1, color: AppTheme.neutral200.withOpacity(0.5)),
          Expanded(
            child: _isLoadingActivities
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: 48,
                    ),
                    itemCount: participants.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 48,
                      color: AppTheme.neutral200.withOpacity(0.5),
                    ),
                    itemBuilder: (context, index) {
                      final p = participants[index];
                      final pId = p['id'] as int;
                      final currentActivityId =
                          p['intensive_activity_id'] as int?;
                      final pendingUpgradeId = p['pending_upgrade_id'] as int?;
                      final isPending = pendingUpgradeId != null;
                      final canEdit = currentActivityId != null && !isPending;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.neutral50,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.neutral200,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 20,
                                  color: AppTheme.neutral500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (p['full_name'] ?? 'Participante')
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    if (p['weeks'] != null &&
                                        (p['weeks'] as List).isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.successColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.successColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          'Semanas Registradas: ${(p['weeks'] as List).join(', ')}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.successColor,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppTheme.neutral900
                                  : AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isPending
                                    ? AppTheme.warningColor.withValues(
                                        alpha: 0.5,
                                      )
                                    : (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppTheme.neutral700
                                          : AppTheme.neutral200),
                              ),
                            ),
                            child: isPending
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${_intensiveActivities.firstWhere((act) => act['id'] == pendingUpgradeId, orElse: () => {'name': 'Actividad'})['name']} (Pendiente de pago)',
                                          style: TextStyle(
                                            color: AppTheme.warningColor
                                                .withValues(alpha: 0.8),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.access_time_rounded,
                                        color: AppTheme.warningColor,
                                        size: 18,
                                      ),
                                    ],
                                  )
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<int?>(
                                      value: currentActivityId,
                                      isExpanded: true,
                                      isDense: true,
                                      icon: canEdit
                                          ? const Icon(
                                              Icons.unfold_more_rounded,
                                              color: AppTheme.primaryColor,
                                            )
                                          : const Icon(
                                              Icons.lock_rounded,
                                              color: AppTheme.neutral400,
                                              size: 16,
                                            ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: canEdit
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onSurface
                                            : AppTheme.neutral400,
                                      ),
                                      hint: const Text(
                                        'Regular (Sin verano intensivo)',
                                      ),
                                      items: [
                                        const DropdownMenuItem<int?>(
                                          value: null,
                                          child: Text(
                                            'Regular (Sin verano intensivo)',
                                          ),
                                        ),
                                        ..._intensiveActivities.map((act) {
                                          return DropdownMenuItem<int?>(
                                            value: act['id'] as int,
                                            child: Text(
                                              act['name'] as String,
                                              style: TextStyle(
                                                color: canEdit
                                                    ? AppTheme.primaryColor
                                                    : AppTheme.neutral500,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                      onChanged: (!_isSaving && canEdit)
                                          ? (newId) {
                                              _updateActivity(pId, newId);
                                            }
                                          : null,
                                    ),
                                  ),
                          ),
                          if (!canEdit && !isPending) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: _isSaving
                                    ? null
                                    : () {
                                        _showUpgradeActivitySelector(
                                          context,
                                          pId,
                                        );
                                      },
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Contratar Verano Intensivo',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.vibrantGold,
                                  backgroundColor: AppTheme.primaryColor
                                      .withOpacity(0.08),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppTheme.vibrantGold.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
