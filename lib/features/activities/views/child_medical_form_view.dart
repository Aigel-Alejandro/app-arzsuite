import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';

class ChildMedicalFormView extends StatefulWidget {
  const ChildMedicalFormView({super.key});

  @override
  State<ChildMedicalFormView> createState() => _ChildMedicalFormViewState();
}

class _ChildMedicalFormViewState extends State<ChildMedicalFormView> {
  // Variables de control de estado
  bool _isSharedWithClub = false;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ficha Médica',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.neutral900,
                      ),
                ),
                const Icon(Icons.medical_services_rounded, color: AppTheme.primaryColor),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                border: Border.all(color: AppTheme.neutral100),
              ),
              child: Column(
                children: [
                  _MedicalInput(label: 'Tipo de Sangre', initial: 'O+'),
                  const Divider(height: 24, color: AppTheme.neutral100),
                  _MedicalInput(label: 'Alergias', initial: 'Ninguna conocida'),
                  const Divider(height: 24, color: AppTheme.neutral100),
                  _MedicalInput(label: 'Medicamentos habituales', initial: 'Ninguno'),
                  const Divider(height: 24, color: AppTheme.neutral100),
                  _MedicalInput(label: 'Seguro / Número de Póliza', initial: 'GNP - #1234567'),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            
            Text(
              'Documentos (Privacidad)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.neutral900,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                border: Border.all(color: AppTheme.neutral100),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.5),
                    activeThumbColor: AppTheme.primaryColor,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Compartir con Institución', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Si está activo, el Admin podrá ver los documentos; de lo contrario es totalmente privado.', style: TextStyle(fontSize: 12)),
                    value: _isSharedWithClub,
                    onChanged: (v) {
                       setState(() => _isSharedWithClub = v);
                       // PUT a CakePHP para actualizar la privacidad
                    },
                  ),
                  const Divider(height: 24, color: AppTheme.neutral100),
                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.dangerColor),
                    title: const Text('Acta de Nacimiento'),
                    trailing: const Icon(Icons.remove_red_eye_rounded, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.dangerColor),
                    title: const Text('CURP'),
                    trailing: const Icon(Icons.remove_red_eye_rounded, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {},
                  )
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _MedicalInput extends StatelessWidget {
  final String label;
  final String initial;

  const _MedicalInput({required this.label, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.neutral500, fontSize: 12)),
        const SizedBox(height: 4),
        Text(initial, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.neutral900)),
      ],
    );
  }
}
