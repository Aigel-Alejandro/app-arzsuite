import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/api_client_notifier.dart';

// ----- Models -----
class HealthInfo {
  final String? bloodType;
  final String? allergies;
  final String? conditions;
  final String? medicalNotes;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? inbodyUrl;

  HealthInfo({
    this.bloodType,
    this.allergies,
    this.conditions,
    this.medicalNotes,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.inbodyUrl,
  });

  factory HealthInfo.fromJson(Map<String, dynamic> json) {
    return HealthInfo(
      bloodType: json['blood_type'],
      allergies: json['allergies'],
      conditions: json['conditions'],
      medicalNotes: json['medical_notes'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_phone'],
      inbodyUrl: json['inbody_url'],
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

class HealthData {
  final HealthInfo? healthInfo;
  final List<MedicalRecord> medicalRecords;

  HealthData({this.healthInfo, required this.medicalRecords});

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      healthInfo: json['health_info'] != null ? HealthInfo.fromJson(json['health_info']) : null,
      medicalRecords: (json['medical_records'] as List?)
              ?.map((e) => MedicalRecord.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// ----- Provider -----
final healthProvider = FutureProvider.autoDispose<HealthData>((ref) async {
  final apiClient = ref.watch(apiClientNotifierProvider);
  if (apiClient == null) throw Exception('API Client no disponible');

  final response = await apiClient.dio.get('arzsuite/health');
  
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
class HealthView extends ConsumerWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsyncValue = ref.watch(healthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salud y Expediente Médico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: healthAsyncValue.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildAccordion(
              context: context,
              icon: Icons.monitor_weight_rounded,
              title: 'INBODY',
              subtitle: 'Resultados de composición corporal',
              children: [
                if (data.healthInfo?.inbodyUrl != null && data.healthInfo!.inbodyUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Enlace: ${data.healthInfo!.inbodyUrl}'),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('No hay enlace INBODY registrado.', style: TextStyle(color: AppTheme.neutral500)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAccordion(
              context: context,
              icon: Icons.health_and_safety_rounded,
              title: 'Información Médica',
              subtitle: 'Datos de salud y contacto de emergencia',
              color: AppTheme.dangerColor,
              children: [
                _buildInfoGrid(data.healthInfo),
              ],
            ),
            const SizedBox(height: 16),
            _buildAccordion(
              context: context,
              icon: Icons.medical_services_rounded,
              title: 'Expediente Médico',
              subtitle: 'Historial de visitas al servicio médico',
              color: AppTheme.warningColor,
              children: [
                if (data.medicalRecords.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('No se han registrado visitas médicas.', style: TextStyle(color: AppTheme.neutral500)),
                  )
                else
                  _buildMedicalRecordsList(context, data.medicalRecords),
              ],
            ),
            const SizedBox(height: 48), // Bottom padding
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: $err', style: const TextStyle(color: AppTheme.dangerColor)),
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
    Color color = AppTheme.primaryColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: color,
          collapsedIconColor: isDark ? AppTheme.neutral400 : AppTheme.neutral500,
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontSize: 12),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoGrid(HealthInfo? info) {
    if (info == null) {
      return const Text('Sin información médica registrada.', style: TextStyle(color: AppTheme.neutral500));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInfoItem('Tipo de sangre', info.bloodType)),
            Expanded(child: _buildInfoItem('Alergias', info.allergies)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInfoItem('Padecimientos', info.conditions)),
            Expanded(child: _buildInfoItem('Notas médicas', info.medicalNotes)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInfoItem('Contacto de emergencia', info.emergencyContactName)),
            Expanded(child: _buildInfoItem('Teléfono de emergencia', info.emergencyContactPhone)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoItem('URL INBODY', info.inbodyUrl),
      ],
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutral500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value != null && value.isNotEmpty ? value : '—',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalRecordsList(BuildContext context, List<MedicalRecord> records) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : AppTheme.neutral100.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutral200.withOpacity(isDark ? 0.1 : 0.5)),
          ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.attentionType ?? 'Atención',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRecordRow('Motivo de visita', record.visitReason),
              const SizedBox(height: 8),
              _buildRecordRow('Diagnóstico', record.diagnosis),
              const SizedBox(height: 8),
              _buildRecordRow('Resumen', record.summary),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildRecordRow('Personal Médico', record.medicalPersonnel, singleLine: true)),
                  Expanded(child: _buildRecordRow('Enfermería', record.nursing, singleLine: true)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordRow(String label, String? value, {bool singleLine = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.neutral500),
        ),
        const SizedBox(height: 2),
        Text(
          value != null && value.trim().isNotEmpty ? value : '—',
          style: const TextStyle(fontSize: 13),
          maxLines: singleLine ? 1 : null,
          overflow: singleLine ? TextOverflow.ellipsis : null,
        ),
      ],
    );
  }
}
