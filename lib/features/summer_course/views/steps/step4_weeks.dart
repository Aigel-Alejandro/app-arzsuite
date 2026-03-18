import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';

class Step4Weeks extends ConsumerWidget {
  const Step4Weeks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selección de Semanas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Elige las semanas de participación para cada integrante:'),
          
          const SizedBox(height: 20),

          ...state.selectedParticipants.map((participant) {
            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(participant.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                participant.isSocio 
                                    ? 'Socio (${participant.member?.membershipNumber})' 
                                    : 'Invitado',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatter.format(participant.totalCost),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildWeeksSelector(participant, notifier),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(
                  formatter.format(state.totalGeneral),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWeeksSelector(participant, notifier) {
    final weeks = [
      {'id': 1, 'label': 'Semana 1', 'date': '21 – 25 julio'},
      {'id': 2, 'label': 'Semana 2', 'date': '28 jul – 1 ago'},
      {'id': 3, 'label': 'Semana 3', 'date': '4 – 8 ago'},
      {'id': 4, 'label': 'Semana 4', 'date': '11 – 15 ago'},
      {'id': 5, 'label': 'Semana 5', 'date': '18 – 22 ago'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: weeks.map((w) {
        final id = w['id'] as int;
        final isSelected = participant.selectedWeekIds.contains(id);
        
        return ChoiceChip(
          label: Column(
            children: [
              Text(w['label'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
              Text(w['date'] as String, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : Colors.grey)),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            final currentWeeks = List<int>.from(participant.selectedWeekIds);
            if (selected) {
              currentWeeks.add(id);
            } else {
              currentWeeks.remove(id);
            }
            notifier.updateWeeks(participant.identifier, currentWeeks);
          },
          selectedColor: Colors.blue.shade700,
          backgroundColor: Colors.grey.shade100,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }).toList(),
    );
  }
}
