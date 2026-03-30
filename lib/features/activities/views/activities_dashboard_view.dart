import 'package:flutter/material.dart';
import 'package:app_arzsuite/features/activities/views/activities_list_view.dart';

class ActivitiesDashboardView extends StatelessWidget {
  const ActivitiesDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Punto de entrada central: Directorio de Actividades
    return const ActivitiesListView(isSubscribed: false, useLayout: true);
  }
}

