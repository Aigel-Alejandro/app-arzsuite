import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/activities/views/trainer_dashboard_view.dart';
import 'package:app_arzsuite/features/activities/views/child_selector_view.dart';
import 'package:app_arzsuite/features/activities/views/child_detail_profile_view.dart';

/// Este widget actúa como Router Principal del Módulo de Actividades.
/// A través de Riverpod, evaluaría el rol del usuario conectado.
/// Para fines de demostración, incluye un selector manual simulado.
class ActivitiesDashboardView extends StatefulWidget {
  const ActivitiesDashboardView({super.key});

  @override
  State<ActivitiesDashboardView> createState() => _ActivitiesDashboardViewState();
}

class _ActivitiesDashboardViewState extends State<ActivitiesDashboardView> {
  // Simulación de estados provenientes del Provider
  String _mockRole = 'tutor_multiple'; // Puede ser 'profesor', 'tutor_unico', 'tutor_multiple'

  @override
  Widget build(BuildContext context) {
    // Scaffold contenedor solo para mostrar el control de debug simulando el backend
    // En producción este scaffold no existiría, retornaría directo la vista
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador de Roles (Router)'),
        backgroundColor: AppTheme.neutral900,
        foregroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            dropdownColor: AppTheme.neutral900,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            value: _mockRole,
            items: [
              const DropdownMenuItem(value: 'profesor', child: Text('Ver como: Profesor')),
              const DropdownMenuItem(value: 'tutor_unico', child: Text('Ver como: Tutor (1 hijo)')),
              const DropdownMenuItem(value: 'tutor_multiple', child: Text('Ver como: Tutor (+2 hijos)')),
            ],
            onChanged: (v) => setState(() => _mockRole = v!),
          )
        ],
      ),
      body: _getRoutedView(),
    );
  }

  Widget _getRoutedView() {
    switch (_mockRole) {
      case 'profesor':
        return const TrainerDashboardView();
      case 'tutor_unico':
        return const ChildDetailProfileView(childName: 'Juanito Pérez');
      case 'tutor_multiple':
      default:
        return const ChildSelectorView();
    }
  }
}
