import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../../../core/widgets/toast_alerts.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/custom_premium_app_bar.dart';

// ----- Validators & Formatters -----
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 10) text = text.substring(0, 10);
    
    String result = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 6) result += '-';
      result += text[i];
    }
    
    // Attempt cursor preservation logic if typing at end, else clamp
    int selectionIndex = newValue.selection.end;
    if (selectionIndex >= newValue.text.length) {
      selectionIndex = result.length;
    } else {
      // Basic approximation for UX
      selectionIndex = result.length;
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

// ----- Models -----
class HealthInfo {
  final String? bloodType;
  final String? allergies;
  final String? conditions;
  final String? medicalNotes;
  final String? emergencySocioId;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  HealthInfo({
    this.bloodType,
    this.allergies,
    this.conditions,
    this.medicalNotes,
    this.emergencySocioId,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  factory HealthInfo.fromJson(Map<String, dynamic> json) {
    return HealthInfo(
      bloodType: json['blood_type'],
      allergies: json['allergies'],
      conditions: json['conditions'],
      medicalNotes: json['medical_notes'],
      emergencySocioId: json['emergency_socio_id']?.toString(),
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_phone'],
    );
  }
}

class MedicalRecord {
  final int id;
  final String? visitDate;
  final String? attentionType;
  final String? visitReason;
  final String? diagnosis;
  final String? summary;
  final String? medicalPersonnel;
  final String? nursing;

  MedicalRecord({
    required this.id,
    this.visitDate,
    this.attentionType,
    this.visitReason,
    this.diagnosis,
    this.summary,
    this.medicalPersonnel,
    this.nursing,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      visitDate: json['visit_date'],
      attentionType: json['attention_type'],
      visitReason: json['visit_reason'],
      diagnosis: json['diagnosis'],
      summary: json['summary'],
      medicalPersonnel: json['medical_personnel'],
      nursing: json['nursing'],
    );
  }
}

class FamilyMember {
  final int id;
  final String name;
  final int? age;
  final String? phone;
  final String? relationship;

  FamilyMember({
    required this.id,
    required this.name,
    this.age,
    this.phone,
    this.relationship,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      phone: json['phone'],
      relationship: json['relationship'],
    );
  }
}

class HealthData {
  final HealthInfo? healthInfo;
  final List<MedicalRecord> medicalRecords;
  final List<FamilyMember> familyMembers;
  final bool canEditMedicalData;

  HealthData({
    this.healthInfo, 
    required this.medicalRecords, 
    required this.familyMembers,
    this.canEditMedicalData = false,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      healthInfo: json['health_info'] != null ? HealthInfo.fromJson(json['health_info']) : null,
      canEditMedicalData: json['can_edit_medical_data'] == true,
      medicalRecords: (json['medical_records'] as List?)
              ?.map((e) => MedicalRecord.fromJson(e))
              .toList() ??
          [],
      familyMembers: (json['family_members'] as List?)
              ?.map((e) => FamilyMember.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// ----- Provider -----
final healthProvider = FutureProvider.autoDispose<HealthData>((ref) async {
  final apiClient = ref.watch(apiClientNotifierProvider);
  if (apiClient == null) throw Exception('API Client no disponible');

  final response = await apiClient.dio.get(
    'arzsuite/health',
    queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
  );
  
  var responseData = response.data;
  if (responseData is String) {
    responseData = jsonDecode(responseData);
  }
  
  if (response.statusCode == 200 && responseData['success'] == true) {
    return HealthData.fromJson(responseData['data']);
  } else {
    throw Exception(responseData['message'] ?? 'Error al obtener información de salud');
  }
});

// ----- View -----
class HealthView extends ConsumerStatefulWidget {
  const HealthView({super.key});

  @override
  ConsumerState<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends ConsumerState<HealthView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  bool _isInit = false;
  
  // Info Médica Controllers
  final _bloodTypeCtrl = TextEditingController();
  final _allergiesCtrl = TextEditingController();
  final _conditionsCtrl = TextEditingController();
  final _medicalNotesCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();

  // Expediente Controller
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  DateTime? _selectedDateFilter;
  
  String? _selectedContactId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bloodTypeCtrl.dispose();
    _allergiesCtrl.dispose();
    _conditionsCtrl.dispose();
    _medicalNotesCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _initControllers(HealthInfo? info, List<FamilyMember> familyMembers) {
    if (_isInit) return;
    if (info != null) {
       _bloodTypeCtrl.text = info.bloodType ?? '';
       _allergiesCtrl.text = info.allergies ?? '';
       _conditionsCtrl.text = info.conditions ?? '';
       _medicalNotesCtrl.text = info.medicalNotes ?? '';
       
       final eName = info.emergencyContactName ?? '';
       _emergencyNameCtrl.text = eName;
       
       String phone = info.emergencyContactPhone ?? '';
       phone = phone.replaceAll(RegExp(r'\D'), '');
       if (phone.length > 10) phone = phone.substring(0, 10);
       String formattedPhone = '';
       for (int i = 0; i < phone.length; i++) {
         if (i == 2 || i == 6) formattedPhone += '-';
         formattedPhone += phone[i];
       }
       _emergencyPhoneCtrl.text = formattedPhone;
       
       if (info.emergencySocioId != null && info.emergencySocioId!.isNotEmpty) {
           _selectedContactId = info.emergencySocioId;
       } else if (eName.isNotEmpty) {
           // Find in family by exact name match
           final match = familyMembers.where((m) => m.name == eName).firstOrNull;
           if (match != null) {
               _selectedContactId = match.id.toString();
           } else {
               _selectedContactId = 'externo';
           }
       } else {
           _selectedContactId = null;
       }
    }
    _isInit = true;
  }

  Future<void> _saveHealthInfo() async {
    try {
       final apiClient = ref.read(apiClientNotifierProvider);
       if (apiClient == null) throw Exception('API no disponible');
       
       if (_selectedContactId == null && (_emergencyNameCtrl.text.isNotEmpty || _emergencyPhoneCtrl.text.isNotEmpty)) {
          ToastAlerts.showError(context, 'Por favor, selecciona un tipo de contacto de emergencia');
          return;
       }

       final data = {
          'blood_type': _bloodTypeCtrl.text.trim(),
          'allergies': _allergiesCtrl.text.trim(),
          'conditions': _conditionsCtrl.text.trim(),
          'medical_notes': _medicalNotesCtrl.text.trim(),
          'emergency_socio_id': _selectedContactId == 'externo' ? null : _selectedContactId,
          'emergency_contact_name': _emergencyNameCtrl.text.trim(),
          'emergency_contact_phone': _emergencyPhoneCtrl.text.replaceAll(RegExp(r'\D'), ''),
       };
       
       final res = await apiClient.dio.post('arzsuite/health/update', data: data);
       
       if (res.statusCode == 200 || res.statusCode == 201) {
          if (!mounted) return;
          _isInit = false;
          ref.invalidate(healthProvider);
          ToastAlerts.showSuccess(context, 'Información guardada correctamente');
       } else {
          throw Exception('Error al guardar');
       }
    } catch (e) {
       if (!mounted) return;
       ToastAlerts.showError(context, 'No se pudo guardar. Verifica tus permisos o conexión.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthAsyncValue = ref.watch(healthProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomPremiumAppBar(
        title: 'Salud y Expediente',
        subtitle: 'Tu información médica',
        icon: Icons.medical_information_outlined,
      ),
      body: healthAsyncValue.when(
        data: (data) {
          if (!healthAsyncValue.isLoading && !healthAsyncValue.isRefreshing) {
            _initControllers(data.healthInfo, data.familyMembers);
          }

          return Column(
            children: [
              Container(
                height: 42,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(30),
                  border: isDark ? Border.all(color: Colors.white.withOpacity(0.1)) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        splashBorderRadius: BorderRadius.circular(30),
                        indicator: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.15) : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: isDark ? [] : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: isDark ? Colors.white : AppTheme.primaryColor,
                        unselectedLabelColor: AppTheme.neutral500,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                        labelPadding: EdgeInsets.zero,
                        tabs: const [
                          Tab(child: Align(alignment: Alignment.center, child: Text('Info Médica'))),
                          Tab(child: Align(alignment: Alignment.center, child: Text('Expediente'))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.primaryColor.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _isInit = false;
                          ref.invalidate(healthProvider);
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        color: AppTheme.primaryColor,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                        tooltip: 'Verificar permisos y refrescar',
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildHealthInfoTab(data.healthInfo, data.canEditMedicalData, data.familyMembers),
                    _buildMedicalRecordsTab(data.medicalRecords),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor)),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppTheme.dangerColor),
                const SizedBox(height: 16),
                const Text('Ocurrió un error', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(err.toString(), textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.neutral500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- TAB: INFO MÉDICA ---
  Widget _buildHealthInfoTab(HealthInfo? info, bool canEdit, List<FamilyMember> familyMembers) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Mejor contraste para la alerta en light mode
    final warningBgColor = isDark ? AppTheme.warningColor.withOpacity(0.1) : const Color(0xFFFFF8EA);
    final warningBorderColor = isDark ? AppTheme.warningColor.withOpacity(0.3) : const Color(0xFFFFE0A3);
    final warningIconColor = isDark ? AppTheme.warningColor : const Color(0xFFE5A125); // Ocre/Oro más oscuro y legible
    final warningTextColor = isDark ? AppTheme.warningColor : const Color(0xFFB37300); // Texto aún más oscuro
    
    return RefreshIndicator(
      color: AppTheme.primaryColor,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onRefresh: () async {
         _isInit = false;
         ref.invalidate(healthProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
             decoration: BoxDecoration(
               color: warningBgColor,
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: warningBorderColor),
             ),
             child: Row(
               children: [
                 Icon(Icons.info_outline, color: warningIconColor),
                 const SizedBox(width: 12),
                 Expanded(
                   child: Text(
                     canEdit 
                         ? 'Ahora puedes actualizar tu información médica. Los cambios se guardarán directamente.'
                         : 'Tu información está protegida. Si deseas actualizarla, contacta a la administración para autorizar tu edición.',
                     style: TextStyle(fontSize: 13, color: warningTextColor, fontWeight: FontWeight.w500),
                   ),
                 ),
               ],
             ),
           ),
           const SizedBox(height: 24),
           
           Container(
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               color: Theme.of(context).colorScheme.surface,
               borderRadius: BorderRadius.circular(20),
               border: Border.all(color: AppTheme.neutral200.withOpacity(0.5)),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Row(
                   children: [
                     Icon(Icons.monitor_heart_outlined, color: AppTheme.primaryColor, size: 20),
                     SizedBox(width: 8),
                     Text('Datos Médicos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   ],
                 ),
                 const SizedBox(height: 16),
                 _buildSensitiveField('Tipo de Sangre', canEdit, controller: _bloodTypeCtrl, icon: Icons.bloodtype_outlined),
                 const SizedBox(height: 16),
                 _buildSensitiveField('Alergias', canEdit, controller: _allergiesCtrl, icon: Icons.no_food_outlined),
                 const SizedBox(height: 16),
                 _buildSensitiveField('Padecimientos', canEdit, controller: _conditionsCtrl, icon: Icons.sick_outlined),
                 const SizedBox(height: 16),
                 _buildSensitiveField('Notas Médicas adicionales', canEdit, controller: _medicalNotesCtrl, icon: Icons.note_alt_outlined),
               ],
             ),
           ),
           
           const SizedBox(height: 24),
           
           Container(
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               color: Theme.of(context).colorScheme.surface,
               borderRadius: BorderRadius.circular(20),
               border: Border.all(color: AppTheme.neutral200.withOpacity(0.5)),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Row(
                   children: [
                     Icon(Icons.contact_phone_outlined, color: AppTheme.primaryColor, size: 20),
                     SizedBox(width: 8),
                     Text('Contacto de Emergencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   ],
                 ),
                 const SizedBox(height: 16),
                 _buildContactTypeDropdown(canEdit, familyMembers),
                 if (_selectedContactId == 'externo') ...[
                     const SizedBox(height: 16),
                     _buildSensitiveField('Nombre del Contacto Externo', canEdit, controller: _emergencyNameCtrl, icon: Icons.person_outline),
                 ],
                 const SizedBox(height: 16),
                 _buildSensitiveField('Teléfono de Emergencia', canEdit, controller: _emergencyPhoneCtrl, icon: Icons.phone_outlined, isPhone: true),
                 
                 if (_selectedContactId == 'externo') ...[
                     const SizedBox(height: 12),
                     const Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                             Icon(Icons.info_outline, color: AppTheme.warningColor, size: 16),
                             SizedBox(width: 8),
                             Expanded(child: Text('Se recomienda que el contacto de emergencia sea mayor a 18 años.', style: TextStyle(fontSize: 12, color: AppTheme.neutral500))),
                         ],
                     ),
                 ],
               ],
             ),
           ),
           
           if (canEdit) ...[
             const SizedBox(height: 32),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: _saveHealthInfo,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppTheme.primaryColor,
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(vertical: 14),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
                 child: const Text('Guardar Información', style: TextStyle(fontWeight: FontWeight.bold)),
               ),
             ),
           ],
           const SizedBox(height: 48),
        ],
      )
    );
  }

  Widget _buildContactTypeDropdown(bool canEdit, List<FamilyMember> familyMembers) {
      final items = <DropdownMenuItem<String>>[];
      
      for (final member in familyMembers) {
          final isMinor = member.age != null && member.age! < 18;
          items.add(DropdownMenuItem(
              value: member.id.toString(),
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Icon(Icons.person, size: 20, color: isMinor ? AppTheme.neutral400 : AppTheme.neutral500),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                          member.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: isMinor ? AppTheme.neutral400 : null,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isMinor)
                                        Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text('${member.relationship ?? "Beneficiario"} (Menor de edad)', style: const TextStyle(fontSize: 11, color: AppTheme.dangerColor)),
                                        )
                                      else
                                        Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text(member.relationship ?? 'Beneficiario', style: const TextStyle(fontSize: 11, color: AppTheme.neutral400)),
                                        ),
                                  ],
                              ),
                          ),
                      ],
                  ),
              ),
          ));
      }
      
      items.add(const DropdownMenuItem(
          value: 'externo',
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                  children: [
                      Icon(Icons.person_add_alt_1, size: 20, color: AppTheme.primaryColor),
                      SizedBox(width: 10),
                      Text('Contacto Externo / Otro', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
              ),
          ),
      ));

      return DropdownButtonFormField<String>(
          value: _selectedContactId,
          decoration: InputDecoration(
            labelText: 'Seleccionar Beneficiario',
            labelStyle: const TextStyle(fontSize: 13),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutral200.withOpacity(0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          isExpanded: true,
          itemHeight: null,
          items: items,
          selectedItemBuilder: (BuildContext context) {
              return items.map((DropdownMenuItem<String> item) {
                  final String id = item.value!;
                  if (id == 'externo') {
                      return const Row(
                          children: [
                              Icon(Icons.person_add_alt_1, size: 20, color: AppTheme.primaryColor),
                              SizedBox(width: 10),
                              Expanded(child: Text('Contacto Externo / Otro', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis)),
                          ],
                      );
                  }
                  final match = familyMembers.where((m) => m.id.toString() == id).firstOrNull;
                  if (match == null) return const SizedBox.shrink();
                  
                  final isMinor = match.age != null && match.age! < 18;
                  return Row(
                      children: [
                          Icon(Icons.person, size: 20, color: isMinor ? AppTheme.neutral400 : AppTheme.neutral500),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(
                                  match.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: isMinor ? AppTheme.neutral400 : null,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                              ),
                          ),
                      ],
                  );
              }).toList();
          },
          onChanged: canEdit 
              ? (val) {
                  if (val == null) return;
                  
                  if (val != 'externo') {
                      final match = familyMembers.where((m) => m.id.toString() == val).firstOrNull;
                      if (match != null) {
                          if (match.age != null && match.age! < 18) {
                              ToastAlerts.showError(context, 'No puedes seleccionar a un beneficiario menor de 18 años como contacto de emergencia.');
                              // Do not update the state to the invalid selection
                              return;
                          }
                          _emergencyNameCtrl.text = match.name;
                          if (match.phone != null && match.phone!.isNotEmpty) {
                              String phone = match.phone!.replaceAll(RegExp(r'\D'), '');
                              if (phone.length > 10) phone = phone.substring(0, 10);
                              String formattedPhone = '';
                              for (int i = 0; i < phone.length; i++) {
                                  if (i == 2 || i == 6) formattedPhone += '-';
                                  formattedPhone += phone[i];
                              }
                              _emergencyPhoneCtrl.text = formattedPhone;
                          } else {
                              _emergencyPhoneCtrl.text = '';
                          }
                      }
                  } else {
                      _emergencyNameCtrl.text = '';
                      _emergencyPhoneCtrl.text = '';
                  }
                  
                  setState(() {
                      _selectedContactId = val;
                  });
              }
              : null,
      );
  }

  Widget _buildSensitiveField(String label, bool canEdit, {required TextEditingController controller, IconData? icon, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      readOnly: !canEdit,
      keyboardType: isPhone ? TextInputType.number : null,
      inputFormatters: isPhone ? [PhoneInputFormatter()] : null,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: icon != null 
            ? Icon(icon, size: 20, color: AppTheme.neutral400)
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.neutral200.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // --- TAB: EXPEDIENTE ---
  Widget _buildMedicalRecordsTab(List<MedicalRecord> records) {
    final filtered = records.where((r) {
       bool matchesText = true;
       if (_searchQuery.isNotEmpty) {
           final q = _searchQuery.toLowerCase();
           matchesText = (r.diagnosis?.toLowerCase().contains(q) ?? false) ||
                  (r.visitReason?.toLowerCase().contains(q) ?? false) ||
                  (r.medicalPersonnel?.toLowerCase().contains(q) ?? false) ||
                  (r.attentionType?.toLowerCase().contains(q) ?? false);
       }

       bool matchesDate = true;
       if (_selectedDateFilter != null) {
           final dateStr = "${_selectedDateFilter!.year}-${_selectedDateFilter!.month.toString().padLeft(2, '0')}-${_selectedDateFilter!.day.toString().padLeft(2, '0')}";
           matchesDate = r.visitDate != null && r.visitDate!.startsWith(dateStr);
       }

       return matchesText && matchesDate;
    }).toList();

    // Limit to 5 if not searching, to avoid clutter
    final bool isSearching = _searchQuery.isNotEmpty || _selectedDateFilter != null;
    final toShow = !isSearching ? filtered.take(5).toList() : filtered;

    return Column(
      children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, AppTheme.spacingLarge, AppTheme.spacingLarge, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Buscar diagnóstico, médico...',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppTheme.neutral200.withOpacity(0.5))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppTheme.neutral200.withOpacity(0.5))),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.neutral200.withOpacity(0.5)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      _selectedDateFilter == null ? Icons.calendar_month_outlined : Icons.event_busy,
                      color: _selectedDateFilter == null ? AppTheme.primaryColor : AppTheme.dangerColor,
                    ),
                    tooltip: 'Filtrar por fecha',
                    onPressed: () async {
                      if (_selectedDateFilter != null) {
                        setState(() => _selectedDateFilter = null);
                        return;
                      }
                      final dt = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: AppTheme.primaryColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (dt != null) {
                        setState(() => _selectedDateFilter = dt);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_selectedDateFilter != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  side: BorderSide.none,
                  label: Text(
                    'Fecha: ${_selectedDateFilter!.day.toString().padLeft(2, '0')}/${_selectedDateFilter!.month.toString().padLeft(2, '0')}/${_selectedDateFilter!.year}',
                    style: const TextStyle(color: AppTheme.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  onDeleted: () => setState(() => _selectedDateFilter = null),
                  deleteIconColor: AppTheme.primaryColor,
                ),
              ),
            ),
         if (toShow.isEmpty)
           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(AppTheme.spacingLarge),
               child: _buildEmptyState('No se encontraron visitas médicas.'),
             ),
           )
         else
           Expanded(
             child: ListView.builder(
               padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: 8),
               itemCount: toShow.length + (!isSearching && filtered.length > 5 ? 1 : 0),
               itemBuilder: (context, index) {
                  if (index == toShow.length) {
                     return const Padding(
                       padding: EdgeInsets.all(16.0),
                       child: Center(
                         child: Text('Utiliza el buscador superior para encontrar más consultas.', style: TextStyle(color: AppTheme.neutral500, fontSize: 12), textAlign: TextAlign.center)
                       )
                     );
                  }
                  return _buildMedicalRecordCard(toShow[index]);
               },
             ),
           ),
      ],
    );
  }

  Widget _buildMedicalRecordCard(MedicalRecord record) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.white.withOpacity(0.03) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : AppTheme.neutral200;
    final attentionColor = _getAttentionColor(record.attentionType);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: attentionColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            record.visitDate ?? 'Sin fecha',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: attentionColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              record.attentionType ?? 'Atención médica',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: attentionColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      if (record.diagnosis != null && record.diagnosis!.isNotEmpty) ...[
                        const Text('Diagnóstico', style: TextStyle(fontSize: 11, color: AppTheme.neutral500)),
                        Text(record.diagnosis!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                      ],
                      
                      _buildRecordDetailRow('Motivo de visita', record.visitReason),
                      _buildRecordDetailRow('Resumen clínico', record.summary),
                      
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.02) : AppTheme.neutral100.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: _buildPersonnelInfo('Médico', record.medicalPersonnel, Icons.person_outline)),
                            Expanded(child: _buildPersonnelInfo('Enfermería', record.nursing, Icons.medical_services_outlined)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAttentionColor(String? type) {
    if (type == null) return AppTheme.primaryColor;
    final t = type.toLowerCase();
    if (t.contains('urgencia')) return AppTheme.dangerColor;
    if (t.contains('seguimiento')) return AppTheme.warningColor;
    return AppTheme.primaryColor;
  }

  Widget _buildRecordDetailRow(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.neutral500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPersonnelInfo(String role, String? name, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.neutral500),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: const TextStyle(fontSize: 10, color: AppTheme.neutral500)),
              Text(
                name?.isNotEmpty == true ? name! : '—',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : AppTheme.neutral100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppTheme.neutral200.withOpacity(0.5),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: AppTheme.neutral400.withOpacity(0.7)),
          const SizedBox(height: 16),
          Text(
            message, 
            style: const TextStyle(color: AppTheme.neutral500, fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

