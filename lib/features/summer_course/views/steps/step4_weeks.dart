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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? AppTheme.neutral800 : Colors.white;
    final textColor = isDark ? AppTheme.neutral100 : AppTheme.neutral900;
    final subTextColor = isDark ? AppTheme.neutral400 : AppTheme.neutral500;
    final borderColor = isDark ? AppTheme.neutral700 : AppTheme.neutral200.withOpacity(0.5);

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
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona las semanas para cada asistente.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 24),

          ...state.selectedParticipants.map((participant) {
            final socioColor = participant.isSocio ? AppTheme.primaryColor : AppTheme.vibrantGold;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: Border.all(color: borderColor),
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                              ),
                              Text(
                                participant.isSocio ? 'Socio Directo' : 'Invitado Especial',
                                style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600),
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
                  
                  Divider(height: 1, color: isDark ? AppTheme.neutral700 : AppTheme.neutral100, indent: 16, endIndent: 16),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECCIONA LAS SEMANAS DE ASISTENCIA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.neutral400,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildWeeksSelector(context, participant, notifier, state),
                        if (state.intensiveActivities.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'TIPO DE VERANO (OPCIONAL)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.neutral400,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildIntensiveActivitySelector(context, participant, notifier, state),
                        ],
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

  Widget _buildWeeksSelector(BuildContext context, participant, notifier, state) {
    // Restauramos las fechas reales del calendario, porque la tabla de la base de datos (courseCosts) 
    // almacena los PAQUETES DE DESCUENTO POR VOLUMEN (1 SEMANA, 2 SEMANAS, 3 SEMANAS...) 
    // y no las semanas calendáricas individuales.
    final weeks = [
      {'id': 1, 'label': 'Semana 1', 'date': '21-25 Jul'},
      {'id': 2, 'label': 'Semana 2', 'date': '28 Jul-01 Ago'},
      {'id': 3, 'label': 'Semana 3', 'date': '04-08 Ago'},
      {'id': 4, 'label': 'Semana 4', 'date': '11-15 Ago'},
      {'id': 5, 'label': 'Semana 5', 'date': '18-22 Ago'},
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weeks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final w = weeks[index];
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : (isDark ? AppTheme.neutral800 : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : (isDark ? AppTheme.neutral700 : AppTheme.neutral200),
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
                  child: Row(
                    children: [
                      Text(
                        w['label'] as String, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                          color: isSelected ? Colors.white : (isDark ? AppTheme.neutral100 : AppTheme.neutral800),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        w['date'] as String, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11, 
                          color: isSelected ? Colors.white.withOpacity(0.9) : (isDark ? AppTheme.neutral400 : AppTheme.neutral500),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, 
                  color: isSelected ? Colors.white : (isDark ? AppTheme.neutral500 : AppTheme.neutral300), 
                  size: 20
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntensiveActivitySelector(BuildContext context, participant, notifier, state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppTheme.neutral700 : AppTheme.neutral200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: participant.intensiveActivityId,
          hint: Text(
            'Selecciona un tipo de verano...',
            style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontSize: 14),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? AppTheme.neutral400 : AppTheme.neutral500),
          dropdownColor: isDark ? AppTheme.neutral800 : Colors.white,
          onChanged: (int? newValue) {
            notifier.updateIntensiveActivity(participant.identifier, newValue);
          },
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(
                'Regular (Sin verano intensivo)',
                style: TextStyle(
                  color: isDark ? AppTheme.neutral100 : AppTheme.neutral800,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ...state.intensiveActivities.map((activity) {
              final id = activity['id'] as int;
              final name = activity['name'] as String;
              final extraCost = double.tryParse(activity['extra_cost'].toString()) ?? 0.0;
              final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
              
              return DropdownMenuItem<int?>(
                value: id,
                child: Text(
                  '$name ${extraCost > 0 ? '(+${formatter.format(extraCost)})' : ''}',
                  style: TextStyle(
                    color: isDark ? AppTheme.neutral100 : AppTheme.neutral800,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

}

