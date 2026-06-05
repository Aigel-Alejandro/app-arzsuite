import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/toast_alerts.dart';
import '../../../core/network/api_endpoints.dart';
import '../services/summer_course_service.dart';
import '../models/member.dart';
import '../../../core/providers/auth_provider.dart';

class SummerCourseAuthorizedPickupsView extends ConsumerStatefulWidget {
  final Map<String, dynamic> participant;

  const SummerCourseAuthorizedPickupsView({
    super.key,
    required this.participant,
  });

  @override
  ConsumerState<SummerCourseAuthorizedPickupsView> createState() => _SummerCourseAuthorizedPickupsViewState();
}

class _SummerCourseAuthorizedPickupsViewState extends ConsumerState<SummerCourseAuthorizedPickupsView> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _pickups = [];

  @override
  void initState() {
    super.initState();
    _loadPickups();
  }

  Future<void> _loadPickups() async {
    setState(() => _isLoading = true);
    final service = ref.read(summerCourseServiceProvider);
    final participantId = widget.participant['id'] as int;
    final pickups = await service.getAuthorizedPickups(participantId);
    setState(() {
      _pickups = pickups;
      _isLoading = false;
    });
  }

  Future<void> _startAddFlow() async {
    final socioId = widget.participant['socio_id'] ?? widget.participant['titular_id'] ?? ref.read(authProvider)?.id;
    if (socioId == null) {
      _showAddPickupModal();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = ref.read(summerCourseServiceProvider);
      final family = await service.getBeneficiaries(socioId.toString());
      if (!mounted) return;
      Navigator.pop(context); // close loading

      if (family.isEmpty) {
        _showAddPickupModal();
        return;
      }

      _showFamilySelectionModal(family);
    } catch (e) {
      print('ERROR IN STARTADDFLOW: $e');
      if (!mounted) return;
      Navigator.pop(context); // close loading
      _showAddPickupModal(); // Fallback to manual entry
    }
  }

  void _showFamilySelectionModal(List<Member> family) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Seleccionar Familiar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),
                ...family.map((m) => ListTile(
                  title: Text('${m.firstName} ${m.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(m.memberType),
                  trailing: const Icon(Icons.chevron_right),
                  tileColor: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddPickupModal(m);
                  },
                )),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddPickupModal();
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Agregar manualmente a otra persona'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddPickupModal([Member? familyMember]) {
    if (_pickups.length >= 3) {
      ToastAlerts.showWarning(context, 'Límite de seguridad: Máximo 3 personas autorizadas por participante.');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: familyMember != null ? '${familyMember.firstName} ${familyMember.lastName}' : '');
    final relationshipCtrl = TextEditingController(text: familyMember?.memberType ?? '');
    final phoneCtrl = TextEditingController(text: familyMember?.phone ?? '');
    
    Map<String, bool> allowedDays = {
      'lunes': true,
      'martes': true,
      'miercoles': true,
      'jueves': true,
      'viernes': true,
      'sabado': false,
      'domingo': false,
    };
    
    XFile? pickedImage;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bCtx) {
        return StatefulBuilder(
          builder: (sbContext, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(bCtx).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.neutral300, borderRadius: BorderRadius.circular(2))),
                      ),
                      const SizedBox(height: 20),
                      Text('Nuevo Tercero Autorizado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: relationshipCtrl,
                              decoration: InputDecoration(labelText: 'Parentesco', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                              validator: (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                              validator: (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Días Permitidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: allowedDays.keys.map((day) {
                          final isSelected = allowedDays[day]!;
                          return ChoiceChip(
                            label: Text(day.substring(0, 2).toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                            selected: isSelected,
                            selectedColor: AppTheme.primaryColor,
                            onSelected: (selected) {
                              setModalState(() {
                                allowedDays[day] = selected;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('Fotografía (Obligatoria para seguridad visual)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final image = await picker.pickImage(source: ImageSource.camera, maxWidth: 600, imageQuality: 70);
                                if (image != null) {
                                  final name = image.name.toLowerCase();
                                  if (!name.endsWith('.jpg') && !name.endsWith('.jpeg') && !name.endsWith('.png') && !name.endsWith('.webp')) {
                                    ToastAlerts.showError(context, 'Solo se permiten imágenes JPG, PNG o WEBP');
                                    return;
                                  }
                                  setModalState(() => pickedImage = image);
                                }
                              },
                              icon: const Icon(Icons.camera_alt, size: 16),
                              label: const Text('Cámara'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 600, imageQuality: 70);
                                if (image != null) {
                                  final name = image.name.toLowerCase();
                                  if (!name.endsWith('.jpg') && !name.endsWith('.jpeg') && !name.endsWith('.png') && !name.endsWith('.webp')) {
                                    ToastAlerts.showError(context, 'Solo se permiten imágenes JPG, PNG o WEBP');
                                    return;
                                  }
                                  setModalState(() => pickedImage = image);
                                }
                              },
                              icon: const Icon(Icons.photo_library, size: 16),
                              label: const Text('Galería'),
                            ),
                          ),
                        ],
                      ),
                      if (pickedImage != null) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: kIsWeb
                                    ? Image.network(pickedImage!.path, width: 120, height: 120, fit: BoxFit.cover)
                                    : Image.file(io.File(pickedImage!.path), width: 120, height: 120, fit: BoxFit.cover),
                              ),
                              GestureDetector(
                                onTap: () => setModalState(() => pickedImage = null),
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: isSaving ? null : () async {
                            if (!formKey.currentState!.validate()) return;
                            if (pickedImage == null) {
                              ToastAlerts.showError(context, 'La fotografía es obligatoria.');
                              return;
                            }
                            
                            setModalState(() => isSaving = true);
                            try {
                              final bytes = await pickedImage!.readAsBytes();
                              final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                              
                              final payload = {
                                'participant_id': widget.participant['id'],
                                'name': nameCtrl.text.trim(),
                                'relationship': relationshipCtrl.text.trim(),
                                'phone': phoneCtrl.text.trim(),
                                'allowed_days': allowedDays,
                                'photo_base64': base64Image,
                              };
                              
                              await ref.read(summerCourseServiceProvider).addAuthorizedPickup(payload);
                              Navigator.pop(bCtx);
                              ToastAlerts.showSuccess(context, 'Autorizado guardado');
                              _loadPickups();
                            } catch (e) {
                              ToastAlerts.showError(context, e.toString());
                              setModalState(() => isSaving = false);
                            }
                          },
                          child: isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar Autorizado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _showGenerateQrModal(Map<String, dynamic> pickup) {
    int selectedDuration = 15;
    bool isGenerating = false;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bCtx) {
        return StatefulBuilder(
          builder: (sbContext, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Generar QR Dinámico', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 8),
                  Text('Generar pase de salida para ${pickup['name']}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      border: Border.all(color: AppTheme.warningColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.security, color: AppTheme.warningColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Por seguridad, el código expira en el tiempo seleccionado (Máximo 60 minutos).',
                            style: TextStyle(color: AppTheme.warningColor.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text('Validez del QR:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedDuration,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    items: [15, 30, 45, 60].map((mins) {
                      return DropdownMenuItem<int>(
                        value: mins,
                        child: Text('$mins minutos'),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setModalState(() => selectedDuration = v);
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code, color: Colors.white),
                      label: isGenerating ? const CircularProgressIndicator(color: Colors.white) : const Text('Generar y Compartir QR', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isGenerating ? null : () async {
                        setModalState(() => isGenerating = true);
                        try {
                          final service = ref.read(summerCourseServiceProvider);
                          final res = await service.generateDynamicQr(pickup['id'], widget.participant['id'], selectedDuration);
                          
                          if (res != null && res['url'] != null) {
                            Navigator.pop(bCtx);
                            
                            final url = res['url'].toString();
                            final childName = widget.participant['full_name'] ?? 'Participante';
                            final shareText = 'Pase de Salida Curso de Verano:\nNiño(a): $childName\nAutorizado: ${pickup['name']}\nExpira en: $selectedDuration min\n\nAbre este enlace para mostrar el QR:\n$url';
                            
                            if (kIsWeb) {
                              Clipboard.setData(ClipboardData(text: shareText));
                              ToastAlerts.showSuccess(context, 'Link copiado. Redirigiendo...');
                              launchUrl(Uri.parse(url));
                            } else {
                              try {
                                await Share.share(shareText);
                              } catch (e) {
                                Clipboard.setData(ClipboardData(text: shareText));
                                ToastAlerts.showSuccess(context, 'Link copiado.');
                                launchUrl(Uri.parse(url));
                              }
                            }
                          } else {
                            throw Exception('Error al generar QR');
                          }
                        } catch (e) {
                          ToastAlerts.showError(context, e.toString());
                          setModalState(() => isGenerating = false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  Future<void> _deletePickup(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de eliminar a este autorizado?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      )
    );
    
    if (confirm == true) {
      final success = await ref.read(summerCourseServiceProvider).deleteAuthorizedPickup(id);
      if (success) {
        ToastAlerts.showSuccess(context, 'Eliminado correctamente');
        _loadPickups();
      } else {
        ToastAlerts.showError(context, 'Error al eliminar');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terceros Autorizados', style: TextStyle(fontSize: 16)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar lista',
            onPressed: _loadPickups,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPickups,
              child: _pickups.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      const Icon(Icons.family_restroom, size: 64, color: AppTheme.neutral300),
                      const SizedBox(height: 16),
                      const Text('No hay terceros autorizados.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppTheme.neutral600)),
                      const SizedBox(height: 8),
                      const Text('Puedes agregar hasta 3 personas.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppTheme.neutral500)),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _pickups.length,
                itemBuilder: (context, index) {
                  final p = _pickups[index];
                  final photoPath = p['photo_url']?.toString() ?? '';
                  final photoUrl = photoPath.startsWith('http') 
                      ? photoPath 
                      : (photoPath.isNotEmpty ? '${ApiEndpoints.baseUrlCakePHP.replaceAll('/api/', '/')}$photoPath' : '');
                  final allowedDays = p['allowed_days'] as Map<String, dynamic>? ?? {};

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: photoUrl.isNotEmpty
                                ? Image.network(photoUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.person)))
                                : Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.person)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['name'].toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Row(
                                  children: [
                                    Text('${p['relationship']}', style: const TextStyle(fontSize: 14, color: AppTheme.neutral700, fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 8),
                                    if (p['phone'] != null && p['phone'].toString().isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          final uri = Uri.parse('tel:${p['phone']}');
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.phone, size: 14, color: AppTheme.primaryColor),
                                              const SizedBox(width: 4),
                                              Text('${p['phone']}', style: const TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  children: allowedDays.entries.where((e) => e.value == true).map((e) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppTheme.successColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                      child: Text(e.key.substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 10, color: AppTheme.successColor, fontWeight: FontWeight.bold)),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _showGenerateQrModal(p),
                                        icon: const Icon(Icons.qr_code, size: 16),
                                        label: const Text('Generar QR', style: TextStyle(fontSize: 12)),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.primaryColor,
                                          side: const BorderSide(color: AppTheme.primaryColor),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () => _deletePickup(p['id']),
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      tooltip: 'Eliminar',
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: _pickups.length < 3
          ? FloatingActionButton.extended(
              onPressed: _startAddFlow,
              backgroundColor: AppTheme.primaryColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Agregar Autorizado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
}
