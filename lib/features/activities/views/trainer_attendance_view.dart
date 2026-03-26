import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';

class TrainerAttendanceView extends StatelessWidget {
  const TrainerAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista estática para demostrar comportamiento
    final List<Map<String, dynamic>> students = [
      {'name': 'Juanito Pérez', 'present': true},
      {'name': 'María López', 'present': true},
      {'name': 'Carlos Ruiz', 'present': true},
    ];

    return MainLayout(
      activeIndex: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Pase de Lista'),
          centerTitle: true,
        ),
        body: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  color: Colors.white,
                  child: const Text(
                    'Toque para marcar como ausente.',
                    style: TextStyle(color: AppTheme.neutral600),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final isPresent = student['present'];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          border: Border.all(color: AppTheme.neutral100),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                            child: const Icon(Icons.person, color: AppTheme.primaryColor),
                          ),
                          title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPresent ? AppTheme.successColor.withValues(alpha: 0.1) : AppTheme.dangerColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              isPresent ? 'Asistió' : 'Falta',
                              style: TextStyle(
                                color: isPresent ? AppTheme.successColor : AppTheme.dangerColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              student['present'] = !isPresent;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // POST /api/v1/activities/attendance
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lista guardada masivamente')));
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar Lista', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
