import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';

class TutorProfileView extends StatelessWidget {
  const TutorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Perfil Tutor/Alumno'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingLarge),
                _SectionTitle(title: 'Mis Datos (Tutor)'),
                const SizedBox(height: AppTheme.spacingSmall),
                _InfoCard(
                  name: 'Alejandro Pérez',
                  role: 'Tutor',
                  additionalInfo: 'Socio #123456',
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(title: 'Menores a Cargo'),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Agregar'),
                      style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                _ChildCard(
                  name: 'Juanito Pérez',
                  age: 10,
                  status: 'Documentación Pendiente',
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppTheme.neutral900,
          ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String name;
  final String role;
  final String additionalInfo;

  const _InfoCard({required this.name, required this.role, required this.additionalInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        border: Border.all(color: AppTheme.neutral100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            child: const Icon(Icons.person, color: AppTheme.primaryColor, size: 30),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: AppTheme.neutral600)),
                Text(additionalInfo, style: const TextStyle(fontSize: 12, color: AppTheme.neutral400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final String name;
  final int age;
  final String status;

  const _ChildCard({required this.name, required this.age, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        border: Border.all(color: AppTheme.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.child_care_rounded, color: AppTheme.warningColor),
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('$age años', style: const TextStyle(color: AppTheme.neutral600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.dangerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppTheme.dangerColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status,
                    style: const TextStyle(color: AppTheme.dangerColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Subir documentos
                ToastAlerts.showSuccess(context, 'Se abrirá modal para subir foto a server backend');
              },
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Subir Documentos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
