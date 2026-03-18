import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';

class PremiumHorizontalCalendar extends StatefulWidget {
  final ValueChanged<int> onDateSelected;

  const PremiumHorizontalCalendar({super.key, required this.onDateSelected});

  @override
  State<PremiumHorizontalCalendar> createState() => _PremiumHorizontalCalendarState();
}

class _PremiumHorizontalCalendarState extends State<PremiumHorizontalCalendar> {
  int _selectedIndex = 2; // Simular que hoy es el 3er día de la lista

  final List<Map<String, String>> _days = [
    {'day': 'Lun', 'date': '16'},
    {'day': 'Mar', 'date': '17'},
    {'day': 'Mié', 'date': '18'},
    {'day': 'Jue', 'date': '19'},
    {'day': 'Vie', 'date': '20'},
    {'day': 'Sáb', 'date': '21'},
    {'day': 'Dom', 'date': '22'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacingMedium),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
             onTap: () {
               setState(() => _selectedIndex = index);
               widget.onDateSelected(index);
             },
             child: AnimatedContainer(
               duration: const Duration(milliseconds: 300),
               curve: Curves.easeOutCubic,
               width: 70,
               decoration: BoxDecoration(
                 color: isSelected ? AppTheme.primaryColor : Colors.white,
                 borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                 border: Border.all(
                   color: isSelected ? AppTheme.primaryColor : AppTheme.neutral100,
                   width: 1,
                 ),
                 boxShadow: isSelected
                     ? [
                         BoxShadow(
                           color: AppTheme.primaryColor.withValues(alpha: 0.3),
                           blurRadius: 15,
                           offset: const Offset(0, 8),
                         )
                       ]
                     : [
                         BoxShadow(
                           color: Colors.black.withValues(alpha: 0.02),
                           blurRadius: 8,
                           offset: const Offset(0, 4),
                         )
                       ],
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     _days[index]['day']!,
                     style: TextStyle(
                       color: isSelected ? Colors.white70 : AppTheme.neutral500,
                       fontWeight: FontWeight.w600,
                       fontSize: 12,
                     ),
                   ),
                   const SizedBox(height: 8),
                   Text(
                     _days[index]['date']!,
                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
                           color: isSelected ? Colors.white : AppTheme.neutral900,
                           fontWeight: FontWeight.w900,
                         ),
                   ),
                   if (isSelected) ...[
                     const SizedBox(height: 6),
                     Container(
                       width: 6,
                       height: 6,
                       decoration: const BoxDecoration(
                         color: Colors.white,
                         shape: BoxShape.circle,
                       ),
                     )
                   ]
                 ],
               ),
             ),
          );
        },
      ),
    );
  }
}
