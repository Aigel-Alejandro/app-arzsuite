import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/providers/auth_provider.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/activities_list_view.dart';

class ActivitiesDashboardView extends ConsumerWidget {
  const ActivitiesDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMember = ref.watch(authProvider);
    final hasPermission = currentMember?.hasPermission('activities.enroll') ?? false;

    if (!hasPermission) {
      return MainLayout(
        activeIndex: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 80, color: AppTheme.neutral400),
                const SizedBox(height: 24),
                Text(
                  'Módulo Bloqueado',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutral800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tienes permisos para acceder a las Actividades Deportivas y Culturales.\n\nSolicita al socio titular que te otorgue el acceso desde su panel de Control Familiar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.neutral600, fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Punto de entrada central: Directorio de Actividades
    return const ActivitiesListView(isSubscribed: false, useLayout: true);
  }
}

