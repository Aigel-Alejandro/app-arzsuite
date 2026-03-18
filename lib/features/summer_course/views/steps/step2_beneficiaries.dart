import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titular.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Membresía: ${titular.membershipNumber} • Titular', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          const Text(
            'Listado de beneficiarios',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('Selecciona quiénes ingresarán al curso de verano:'),
          
          const SizedBox(height: 15),

          if (state.beneficiariesList.isEmpty)
             const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No se encontraron beneficiarios')),
              )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.beneficiariesList.length,
              itemBuilder: (context, index) {
                final beneficiary = state.beneficiariesList[index];
                final isSelected = state.selectedParticipants.any((p) => p.member?.id == beneficiary.id);
                
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: isSelected,
                  onChanged: (_) => notifier.toggleBeneficiary(beneficiary),
                  title: Text(beneficiary.fullName),
                  subtitle: Text('ID: ${beneficiary.membershipNumber}'),
                  secondary: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    child: const Icon(Icons.family_restroom, size: 20),
                  ),
                );
              },
            ),
          
          const SizedBox(height: 20),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          
          Text(
            '${state.selectedParticipants.where((p) => p.isSocio).length} Beneficiarios seleccionados',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
