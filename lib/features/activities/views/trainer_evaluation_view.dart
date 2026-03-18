import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';

class TrainerEvaluationView extends StatefulWidget {
  const TrainerEvaluationView({super.key});

  @override
  State<TrainerEvaluationView> createState() => _TrainerEvaluationViewState();
}

class _TrainerEvaluationViewState extends State<TrainerEvaluationView> {
  double _tecnica = 3;
  double _condicion = 3;
  double _actitud = 3;
  
  // Asumimos un alumno preseleccionado para el mockup
  String _selectedStudent = 'Juanito Pérez';

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 1,
      child: Scaffold(
        backgroundColor: AppTheme.neutral50,
        appBar: AppBar(
          title: const Text('Generar Evaluación'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveContainer(
            padding: AppTheme.spacingLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seleccione un alumno:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(color: AppTheme.neutral300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStudent,
                      items: ['Juanito Pérez', 'María López'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedStudent = v!),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                
                _EvaluationSlider(title: 'Técnica/Habilidad', value: _tecnica, onChanged: (v) => setState(() => _tecnica = v)),
                _EvaluationSlider(title: 'Condición Física', value: _condicion, onChanged: (v) => setState(() => _condicion = v)),
                _EvaluationSlider(title: 'Actitud y Disciplina', value: _actitud, onChanged: (v) => setState(() => _actitud = v)),
                
                const SizedBox(height: AppTheme.spacingLarge),
                const Text('Comentarios (Opcional):', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppTheme.spacingSmall),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Redactar mensaje para el alumno (La IA puede revisarlo después)...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)),
                  ),
                ),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // POST /api/v1/activities/evaluations
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evaluación enviada con éxito')));
                      Navigator.pop(context);
                    },
                    child: const Text('Enviar Evaluación y Notificar', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EvaluationSlider extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const _EvaluationSlider({required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Text(value.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            )
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: AppTheme.primaryColor,
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
        const SizedBox(height: AppTheme.spacingMedium),
      ],
    );
  }
}
