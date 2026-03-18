import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';

class Step4Weeks extends ConsumerWidget {
  const Step4Weeks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendario de Participación',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona las semanas que cada integrante asistirá al curso. El precio se ajustará automáticamente.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                ),
          ),
          const SizedBox(height: 32),

          ...state.selectedParticipants.map((participant) {
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: AppTheme.neutral100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: participant.isSocio 
                              ? AppTheme.primaryColor.withOpacity(0.1)
                              : AppTheme.vibrantGold.withOpacity(0.1),
                          child: Icon(
                            participant.isSocio ? Icons.person_rounded : Icons.person_add_rounded,
                            color: participant.isSocio ? AppTheme.primaryColor : AppTheme.vibrantGold,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                participant.fullName, 
                                style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.neutral900),
                              ),
                              Text(
                                participant.isSocio 
                                    ? 'Socio Activo' 
                                    : 'Invitado Especial',
                                style: TextStyle(color: AppTheme.neutral500, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formatter.format(participant.totalCost),
                            style: const TextStyle(
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.neutral100),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SEMANAS DISPONIBLES',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.neutral500,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildWeeksSelector(participant, notifier),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL A PAGAR',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Resumen de Orden',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  formatter.format(state.totalGeneral),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWeeksSelector(participant, notifier) {
    final weeks = [
      {'id': 1, 'label': 'Sem 1', 'date': '21-25 Jul'},
      {'id': 2, 'label': 'Sem 2', 'date': '28 Jul-01 Ago'},
      {'id': 3, 'label': 'Sem 3', 'date': '04-08 Ago'},
      {'id': 4, 'label': 'Sem 4', 'date': '11-15 Ago'},
      {'id': 5, 'label': 'Sem 5', 'date': '18-22 Ago'},
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: weeks.map((w) {
        final id = w['id'] as int;
        final isSelected = participant.selectedWeekIds.contains(id);
        
        return GestureDetector(
          onTap: () {
            final currentWeeks = List<int>.from(participant.selectedWeekIds);
            if (isSelected) {
              currentWeeks.remove(id);
            } else {
              currentWeeks.add(id);
            }
            notifier.updateWeeks(participant.identifier, currentWeeks);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : AppTheme.neutral100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  w['label'] as String, 
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppTheme.neutral800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  w['date'] as String, 
                  style: TextStyle(
                    fontSize: 9, 
                    color: isSelected ? Colors.white.withOpacity(0.8) : AppTheme.neutral500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

