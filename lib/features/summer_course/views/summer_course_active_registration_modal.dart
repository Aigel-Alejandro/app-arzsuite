import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _showGeneratePassDialog(BuildContext parentContext, int participantId, String childName) {
    final TextEditingController nameController = TextEditingController();
    bool isGenerating = false;
    bool canLeaveAlone = false;

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dCtx) => StatefulBuilder(
        builder: (sbContext, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Pase de Salida', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Generar pase para $childName', style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la persona autorizada',
                    hintText: 'Ej. Juan Pérez (Chofer)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: AppTheme.neutral50,
                  ),
                  enabled: !isGenerating && !canLeaveAlone,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text(
                    'Autorizo a mi hijo(a) a salir o moverse por el club sin un adulto',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  value: canLeaveAlone,
                  activeColor: AppTheme.primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  onChanged: isGenerating ? null : (bool? value) {
                    setState(() {
                      canLeaveAlone = value ?? false;
                      if (canLeaveAlone) {
                        nameController.text = 'AUTORIZADO PARA MOVERSE SOLO';
                      } else {
                        nameController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isGenerating ? null : () => Navigator.pop(dCtx),
                child: const Text('Cancelar', style: TextStyle(color: AppTheme.neutral500)),
              ),
              ElevatedButton(
                onPressed: isGenerating
                    ? null
                    : () async {
                        final authorizedName = nameController.text.trim();
                        if (authorizedName.isEmpty) {
                          ToastAlerts.showError(dCtx, 'Ingresa el nombre de la persona autorizada.');
                          return;
                        }
                        setState(() => isGenerating = true);
                        try {
                          final service = ref.read(summerCourseServiceProvider);
                          final passData = await service.generatePickupPass(participantId, authorizedName, canLeaveAlone);
                          if (passData != null && passData['url'] != null) {
                            Navigator.pop(dCtx);
                            
                            final shareText = 'Pase de Salida Curso de Verano:\nNiño(a): $childName\nAutorizado: $authorizedName\n\nAbre este enlace para mostrar el QR en la salida:\n${passData['url']}';
                            
                            if (kIsWeb) {
                              Clipboard.setData(ClipboardData(text: shareText));
                              ToastAlerts.showSuccess(parentContext, '¡Pase generado! Link copiado. Da clic en "Ver Pase de Salida Activo" para abrirlo.');
                            } else {
                              try {
                                await Share.share(shareText);
                              } catch (shareError) {
                                Clipboard.setData(ClipboardData(text: shareText));
                                ToastAlerts.showSuccess(parentContext, '¡Pase generado! Link copiado.');
                                launchUrl(Uri.parse(passData['url'].toString()));
                              }
                            }
                            
                            // Invalidar provider para que se actualice la UI automáticamente con el nuevo pase
                            ref.invalidate(activeRegistrationProvider);
                          } else {
                            ToastAlerts.showError(dCtx, 'No se pudo generar el pase.');
                            setState(() => isGenerating = false);
                          }
                        } catch (e) {
                          if (dCtx.mounted) {
                            ToastAlerts.showError(dCtx, 'Error: $e');
                            setState(() => isGenerating = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isGenerating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Generar y Compartir'),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _shareExistingPass(BuildContext context, String childName, Map<String, dynamic> passData) async {
    final authorizedName = passData['authorized_name']?.toString() ?? 'Autorizado';
    final url = passData['url']?.toString() ?? '';
    
    final shareText = 'Pase de Salida Curso de Verano:\nNiño(a): $childName\nAutorizado: $authorizedName\n\nAbre este enlace para mostrar el QR en la salida:\n$url';
    
    try {
      if (kIsWeb) {
        Clipboard.setData(ClipboardData(text: shareText));
        ToastAlerts.showSuccess(context, 'Link copiado. Abriendo pase...');
        launchUrl(Uri.parse(url));
      } else {
        await Share.share(shareText);
      }
    } catch (shareError) {
      Clipboard.setData(ClipboardData(text: shareText));
      ToastAlerts.showSuccess(context, 'Link copiado al portapapeles.');
      launchUrl(Uri.parse(url));
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
                                      const SizedBox(height: 6),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: (p['weeks'] as List).map((weekLabel) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: AppTheme.primaryColor.withOpacity(0.3),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 10,
                                                  color: AppTheme.primaryColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  weekLabel.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: AppTheme.primaryColor,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
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
                            const SizedBox(height: 12),
                            Builder(
                              builder: (context) {
                                final activePickupPass = p['active_pickup_pass'] as Map<String, dynamic>?;
                                final hasActivePass = activePickupPass != null;
                                final passUsedToday = (p['pass_used_today'] as bool?) ?? false;
                                
                                if (passUsedToday) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.successColor.withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle_rounded, size: 20, color: AppTheme.successColor),
                                        SizedBox(width: 8),
                                        Text(
                                          'Salida Registrada Hoy',
                                          style: TextStyle(
                                            color: AppTheme.successColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                
                                if (hasActivePass) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _isSaving ? null : () {
                                        _shareExistingPass(
                                          context,
                                          (p['full_name'] ?? 'Participante').toString(),
                                          activePickupPass,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: AppTheme.warningColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppTheme.warningColor.withOpacity(0.4),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.visibility_rounded, size: 20, color: AppTheme.warningColor),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Ver Pase de Salida Activo',
                                                  style: TextStyle(
                                                    color: AppTheme.warningColor,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Autorizado: ${activePickupPass["authorized_name"]}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.warningColor.withOpacity(0.9),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final canGenerate = p['can_generate_pickup_pass'] == true;
                                final reason = p['reason_cannot_generate']?.toString() ?? 'No se puede generar.';

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _isSaving ? null : () {
                                      if (!canGenerate) {
                                        ToastAlerts.showError(context, reason);
                                        return;
                                      }
                                      _showGeneratePassDialog(
                                        context,
                                        pId,
                                        (p['full_name'] ?? 'Participante').toString(),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: canGenerate 
                                            ? AppTheme.primaryColor.withOpacity(0.08)
                                            : AppTheme.neutral200.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: canGenerate
                                              ? AppTheme.primaryColor.withOpacity(0.3)
                                              : AppTheme.neutral300,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            canGenerate ? Icons.qr_code_2_rounded : Icons.lock_rounded, 
                                            size: 20, 
                                            color: canGenerate ? AppTheme.primaryColor : AppTheme.neutral500
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            canGenerate ? 'Generar Pase de Salida' : 'Generación No Disponible',
                                            style: TextStyle(
                                              color: canGenerate ? AppTheme.primaryColor : AppTheme.neutral500,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
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
