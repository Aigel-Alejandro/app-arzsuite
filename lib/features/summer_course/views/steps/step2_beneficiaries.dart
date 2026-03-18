import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';

class Step2Beneficiaries extends ConsumerWidget {
  const Step2Beneficiaries({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final titular = state.selectedTitular;
    if (titular == null) {
      return const Center(child: Text('Selecciona un titular primero'));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titular Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titular.fullName, 
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppTheme.neutral900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Acción: ${titular.membershipNumber} • SOCIO TITULAR', 
                        style: const TextStyle(color: AppTheme.neutral500, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Beneficiarios Directos',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona a los miembros de la familia que participarán:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                ),
          ),
          
          const SizedBox(height: 24),

          if (state.beneficiariesList.isEmpty)
             const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('No hay beneficiarios registrados bajo esta acción.')),
              )
          else
            ...state.beneficiariesList.map((beneficiary) {
              final isSelected = state.selectedParticipants.any((p) => p.member?.id == beneficiary.id);
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  activeColor: AppTheme.primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: isSelected,
                  onChanged: (_) => notifier.toggleBeneficiary(beneficiary),
                  title: Text(
                    beneficiary.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.neutral900,
                    ),
                  ),
                  subtitle: Text(
                    'No. Credencial: ${beneficiary.membershipNumber}',
                    style: const TextStyle(fontSize: 13, color: AppTheme.neutral500),
                  ),
                  secondary: CircleAvatar(
                    backgroundColor: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.neutral50,
                    child: Icon(
                      Icons.family_restroom_rounded, 
                      size: 20, 
                      color: isSelected ? AppTheme.primaryColor : AppTheme.neutral300,
                    ),
                  ),
                ),
              );
            }).toList(),
          
          const SizedBox(height: 32),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.neutral100,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppTheme.neutral600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${state.selectedParticipants.where((p) => p.isSocio).length} familiares seleccionados para inscripción.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutral700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

