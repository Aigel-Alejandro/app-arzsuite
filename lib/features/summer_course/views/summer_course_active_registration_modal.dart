import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';
import 'package:app_arzsuite/core/network/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'summer_course_authorized_pickups_view.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  Future<void> _updateWeekActivity(int enrollmentWeekId, int? newActivityId) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final service = ref.read(summerCourseServiceProvider);
      final success = await service.updateWeekIntensiveActivity(
        enrollmentWeekId,
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
    XFile? pickedImage;

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dCtx) => StatefulBuilder(
        builder: (sbContext, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Pase de Salida', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
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
                          pickedImage = null;
                        } else {
                          nameController.clear();
                        }
                      });
                    },
                  ),
                  if (!canLeaveAlone) ...[
                    const SizedBox(height: 12),
                    const Text('Foto de la persona autorizada (Opcional):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.neutral700)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isGenerating ? null : () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 70,
                                maxWidth: 600,
                              );
                              if (image != null) {
                                final name = image.name.toLowerCase();
                                if (!name.endsWith('.jpg') && !name.endsWith('.jpeg') && !name.endsWith('.png') && !name.endsWith('.webp')) {
                                  ToastAlerts.showError(context, 'Solo se permiten imágenes JPG, PNG o WEBP');
                                  return;
                                }
                                setState(() {
                                  pickedImage = image;
                                });
                              }
                            },
                            icon: const Icon(Icons.camera_alt, size: 16),
                            label: const Text('Cámara', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isGenerating ? null : () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 70,
                                maxWidth: 600,
                              );
                              if (image != null) {
                                final name = image.name.toLowerCase();
                                if (!name.endsWith('.jpg') && !name.endsWith('.jpeg') && !name.endsWith('.png') && !name.endsWith('.webp')) {
                                  ToastAlerts.showError(context, 'Solo se permiten imágenes JPG, PNG o WEBP');
                                  return;
                                }
                                setState(() {
                                  pickedImage = image;
                                });
                              }
                            },
                            icon: const Icon(Icons.photo_library, size: 16),
                            label: const Text('Galería', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (pickedImage != null) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.network(pickedImage!.path, width: 100, height: 100, fit: BoxFit.cover)
                                  : Image.file(io.File(pickedImage!.path), width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pickedImage = null;
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
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

  void _showCredencialDialog(BuildContext context, Map<String, dynamic> p) {
    final String childName = (p['full_name'] ?? 'Participante').toString();
    final String token = (p['credencial_token'] ?? '').toString();
    final String socio = p['member_number']?.toString().isNotEmpty == true ? p['member_number'].toString() : (p['socio_id']?.toString() ?? '');
    final String socioDisplay = socio.isNotEmpty ? socio : '-';
    final String age = (p['age'] ?? '').toString();
    final String titular = (p['titular_name'] ?? '').toString();
    final String phone = (p['emergency_phone'] ?? '').toString();
    final String phoneDisplay = phone.isNotEmpty ? phone : '-';
    final String photoPath = p['photo_url']?.toString() ?? '';
    final String photoUrl = photoPath.isNotEmpty ? '${ApiEndpoints.baseUrlCakePHP.replaceAll('/api/', '/')}$photoPath' : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dismissible(
          key: const Key('credencial_dismissible'),
          direction: DismissDirection.down,
          onDismissed: (_) {
            Navigator.of(context).pop();
          },
          child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER: Logos & Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo Centro Libanes
                      Column(
                        children: [
                          Image.asset('assets/images/logo-centro-libanes.png', height: 60, fit: BoxFit.contain),
                        ],
                      ),

                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE95123),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('PARTICIPANTE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Inner Background Stack
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Inner Background Container
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 30), // Reduced from 80
                        padding: const EdgeInsets.fromLTRB(16, 80, 16, 24), // Increased from 64 to 80 to separate from logo
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F8FB), // Very light blue/gray
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            // Photo and QR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Photo Box
                                Container(
                                  width: 130,
                                  height: 130, // Perfectly square again
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                                  ),
                                  child: Container(
                                    foregroundDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: const Color(0xFFE95123), width: 2),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: photoUrl.isNotEmpty
                                        ? Image.network(photoUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.person, size: 64, color: Colors.grey))
                                        : const Icon(Icons.person, size: 64, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // QR Box
                                Column(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                                      ),
                                      child: Container(
                                        foregroundDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: const Color(0xFF0C2442), width: 2),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.white, // Ensure white background for the QR
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: QrImageView(
                                          data: token,
                                          version: QrVersions.auto,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0C2442),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text('RECEPCIÓN/ENTREGA', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Fields
                            _buildCredencialField('NOMBRE', childName, titleColor: const Color(0xFF28B5E1)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildCredencialField('NO. SOCIO', socioDisplay, titleColor: const Color(0xFFE95123))),
                                const SizedBox(width: 12),
                                Expanded(child: _buildCredencialField('EDAD', age, titleColor: const Color(0xFFB59A5A))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildCredencialField('NOMBRE DEL TITULAR', titular, titleColor: const Color(0xFF0C2442)),
                            const SizedBox(height: 12),
                            _buildCredencialField('TEL. EMERGENCIA', phoneDisplay, titleColor: const Color(0xFFE95123)),
                          ],
                        ),
                      ),
                      // The Logo
                      Positioned(
                        top: -40, // Moved up to close the gap with the header
                        child: Image.asset(
                          'assets/images/logocurso2026.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24), // Added space before footer line

                  // Footer Line
                  Container(height: 2, color: const Color(0xFFB59A5A)),
                  const SizedBox(height: 16),
                  
                  // Footer Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1426),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'CENTRO LIBANÉS - CURSO DE VERANO 2026',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Wallet Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ToastAlerts.showWarning(context, 'Requiere configuración de certificados Apple Developer en backend.');
                          },
                          icon: const Icon(Icons.apple, color: Colors.black),
                          label: const Text('Apple Wallet', style: TextStyle(color: Colors.black, fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ToastAlerts.showWarning(context, 'Requiere configuración de Google Wallet API en backend.');
                          },
                          icon: const Icon(Icons.wallet, color: Colors.black),
                          label: const Text('Google Wallet', style: TextStyle(color: Colors.black, fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar Credencial', style: TextStyle(color: Colors.grey)),
                  )
                ],
              ),
            ),
          ),
        ), // Close Dialog
        ); // Close Dismissible
      },
    );
  }

  Widget _buildCredencialField(String title, String value, {required Color titleColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.w900, fontSize: 10)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Text(value.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeRegAsync = ref.watch(activeRegistrationProvider);
    final participants =
        activeRegAsync.value?['participants'] as List<dynamic>? ??
        widget.registrationData['participants'] as List<dynamic>? ??
        [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppTheme.surfaceColor 
            : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Header Area with Gradient and Glass effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor.withOpacity(0.1), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.neutral300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.vibrantGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.manage_accounts_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Panel de Participantes',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Gestiona credenciales, pases y disciplinas',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => ref.invalidate(activeRegistrationProvider),
                            icon: const Icon(Icons.refresh_rounded),
                            color: AppTheme.neutral500,
                            tooltip: 'Actualizar',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.05),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded, size: 20),
                            color: AppTheme.neutral600,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.05),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoadingActivities
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 12,
                      bottom: 48,
                    ),
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final p = participants[index];
                      final pId = p['id'] as int;
                      final pendingUpgradeId = p['pending_upgrade_id'] as int?;
                      final isPending = pendingUpgradeId != null;
                      final canEdit = !isPending;
                      
                      final activePickupPass = p['active_pickup_pass'] as Map<String, dynamic>?;
                      final hasActivePass = activePickupPass != null;
                      final passUsedToday = (p['pass_used_today'] as bool?) ?? false;
                      final canGeneratePass = p['can_generate_pickup_pass'] == true;
                      final reason = p['reason_cannot_generate']?.toString() ?? 'No se puede generar.';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? AppTheme.surfaceColor : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card Header
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: AppTheme.neutral200.withOpacity(0.5))),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8F9FA),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: AppTheme.neutral200.withOpacity(0.5)),
                                            ),
                                            child: const Icon(Icons.person_rounded, size: 24, color: AppTheme.neutral500),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              (p['full_name'] ?? 'Participante').toString().toUpperCase(),
                                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (p['weeks'] != null && (p['weeks'] as List).isNotEmpty) ...[
                                            const Text('DISCIPLINAS POR SEMANA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.neutral500, letterSpacing: 0.5)),
                                            const SizedBox(height: 12),
                                            Column(
                                              children: (p['weeks'] as List).map((weekObj) {
                                                if (weekObj is! Map) return const SizedBox.shrink();
                                                final wLabel = weekObj['label']?.toString() ?? '';
                                                final wEnrollmentWeekId = weekObj['enrollment_week_id'] as int?;
                                                final wActivityId = weekObj['intensive_activity_id'] as int?;
                                                
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 12),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 4,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: wActivityId != null ? AppTheme.vibrantGold : AppTheme.neutral300,
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          wLabel,
                                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      if (canEdit && wEnrollmentWeekId != null)
                                                        Container(
                                                          height: 36,
                                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFF8F9FA),
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: AppTheme.neutral200),
                                                          ),
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton<int?>(
                                                              value: wActivityId,
                                                              icon: const Icon(Icons.unfold_more_rounded, size: 16, color: AppTheme.neutral600),
                                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.neutral800),
                                                              items: [
                                                                const DropdownMenuItem(value: null, child: Text('Regular')),
                                                                ..._intensiveActivities.map((act) => DropdownMenuItem(value: act['id'] as int, child: Text(act['name'].toString()))),
                                                              ],
                                                              onChanged: _isSaving ? null : (newId) => _updateWeekActivity(wEnrollmentWeekId, newId),
                                                            ),
                                                          ),
                                                        )
                                                      else
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: AppTheme.neutral50,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Text(
                                                            weekObj['intensive_activity_name']?.toString() ?? 'Regular',
                                                            style: const TextStyle(fontSize: 12, color: AppTheme.neutral600, fontWeight: FontWeight.w800),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                          
                                          // Action Buttons
                                          Row(
                                            children: [
                                              if (p['credencial_token'] != null)
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () => _showCredencialDialog(context, p),
                                                    icon: const Icon(Icons.badge_rounded, size: 20),
                                                    label: const Text('Credencial', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      backgroundColor: AppTheme.primaryColor,
                                                      shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                                                      elevation: 4,
                                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                    ),
                                                  ),
                                                ),
                                              if (p['credencial_token'] != null) const SizedBox(width: 12),
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => SummerCourseAuthorizedPickupsView(participant: p),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(Icons.family_restroom_rounded, size: 20),
                                                  label: const Text('Autorizados', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor: AppTheme.neutral800,
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    side: BorderSide(color: AppTheme.neutral300, width: 1.5),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          if (p['credencial_token'] != null) ...[
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton.icon(
                                                onPressed: _isSaving ? null : () {
                                                  if (hasActivePass) {
                                                    _shareExistingPass(context, (p['full_name'] ?? '').toString(), activePickupPass!);
                                                  } else if (passUsedToday) {
                                                    ToastAlerts.showSuccess(context, 'Salida registrada hoy');
                                                  } else if (canGeneratePass) {
                                                    _showGeneratePassDialog(context, pId, (p['full_name'] ?? '').toString());
                                                  } else {
                                                    ToastAlerts.showError(context, reason);
                                                  }
                                                },
                                                icon: Icon(
                                                  passUsedToday ? Icons.check_circle_rounded : (hasActivePass ? Icons.visibility_rounded : Icons.output_rounded),
                                                  size: 18,
                                                ),
                                                label: Text(
                                                  passUsedToday ? 'Salida Ok' : (hasActivePass ? 'Ver Pase Activo' : 'Generar Pase de Salida'),
                                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: passUsedToday ? AppTheme.successColor : (hasActivePass ? AppTheme.warningColor : AppTheme.neutral800),
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  backgroundColor: passUsedToday ? AppTheme.successColor.withOpacity(0.05) : (hasActivePass ? AppTheme.warningColor.withOpacity(0.05) : const Color(0xFFF8F9FA)),
                                                  side: BorderSide(
                                                    color: passUsedToday ? AppTheme.successColor.withOpacity(0.5) : (hasActivePass ? AppTheme.warningColor.withOpacity(0.5) : AppTheme.neutral200),
                                                    width: 1.5,
                                                  ),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                ),
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            );
                          },
                        ),
          ),
        ],
      ),
    );
  }
}
