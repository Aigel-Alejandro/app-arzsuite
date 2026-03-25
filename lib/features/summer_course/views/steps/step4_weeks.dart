import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/summer_course_state.dart';

class Step4Weeks extends ConsumerWidget {
  const Step4Weeks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fechas y Tarifas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona las semanas para cada asistente.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 24),

          ...state.selectedParticipants.map((participant) {
            final socioColor = participant.isSocio ? AppTheme.primaryColor : AppTheme.vibrantGold;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: Border.all(color: AppTheme.neutral200.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CABECERA DEL PARTICIPANTE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: socioColor.withOpacity(0.1),
                          child: Icon(
                            participant.isSocio ? Icons.person_outline_rounded : Icons.person_add_alt_1_rounded,
                            color: socioColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                participant.fullName, 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.neutral900),
                              ),
                              Text(
                                participant.isSocio ? 'Socio Directo' : 'Invitado Especial',
                                style: TextStyle(color: AppTheme.neutral500, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatter.format(participant.totalCost),
                              style: TextStyle(
                                color: socioColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${participant.selectedWeekIds.length} sem.',
                              style: const TextStyle(fontSize: 10, color: AppTheme.neutral400, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, color: AppTheme.neutral100, indent: 16, endIndent: 16),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'SELECCIONA LAS SEMANAS DE ASISTENCIA',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.neutral400,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getWeeklyCost(participant, formatter, state),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: socioColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildWeeksSelector(participant, notifier),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
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
                      'RESUMEN DE INSCRIPCIÓN',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TOTAL GENERAL',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 13, 
                        fontWeight: FontWeight.bold
                      ),
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
      {'id': 1, 'label': 'Semana 1', 'date': '21-25 Jul'},
      {'id': 2, 'label': 'Semana 2', 'date': '28 Jul-01 Ago'},
      {'id': 3, 'label': 'Semana 3', 'date': '04-08 Ago'},
      {'id': 4, 'label': 'Semana 4', 'date': '11-15 Ago'},
      {'id': 5, 'label': 'Semana 5', 'date': '18-22 Ago'},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.0,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.neutral200,
                width: 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w['label'] as String, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 13,
                          color: isSelected ? Colors.white : AppTheme.neutral800,
                        ),
                      ),
                      Text(
                        w['date'] as String, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10, 
                          color: isSelected ? Colors.white.withOpacity(0.8) : AppTheme.neutral500,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, 
                  color: isSelected ? Colors.white : AppTheme.neutral300, 
                  size: 20
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getWeeklyCost(participant, NumberFormat formatter, SummerCourseState state) {
     if (state.courseCosts.isEmpty) return '';
     
     final baseEntry = state.courseCosts.firstWhere(
       (c) => c['weeks_count'] == 1,
       orElse: () => <String, dynamic>{},
     );
     
     if (baseEntry.isEmpty) return '';

     double basePrice = 0;
     final typeName = participant.type.toString().split('.').last.toLowerCase();
     
     if (typeName == 'socio') {
         basePrice = double.tryParse(baseEntry['socio'].toString()) ?? 0.0;
     } else if (typeName == 'invitado') {
         basePrice = double.tryParse(baseEntry['invitado'].toString()) ?? 0.0;
     } else if (typeName == 'colaborador') {
         basePrice = double.tryParse(baseEntry['colaborador'].toString()) ?? 0.0;
     } else if (typeName == 'invcolaborador') {
         basePrice = double.tryParse(baseEntry['inv_colaborador'].toString()) ?? 0.0;
     }
     
     return '${formatter.format(basePrice)} / SEM';
  }
}

