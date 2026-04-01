import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import '../providers/tournaments_provider.dart';
import 'package:app_arzsuite/features/profile/providers/profile_provider.dart';
import 'package:app_arzsuite/features/tournaments/widgets/premium_tournament_card.dart';

class TournamentsDashboardView extends ConsumerWidget {
  const TournamentsDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color institutionalBlue = Color(0xFF406EBA);
    
    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingLarge),
            
            // Header del listado (Premium look)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catálogo de Torneos',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.neutral900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inscribe a tus beneficiarios en torneos activos y sigue su desempeño.',
                    style: TextStyle(color: AppTheme.neutral500, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLarge),
            
            ref.watch(tournamentsProvider).when(
              data: (tournaments) {
                if (tournaments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppTheme.spacingLarge),
                    child: Center(child: Text("No hay torneos disponibles en este momento.", style: TextStyle(color: AppTheme.neutral500))),
                  );
                }
                
                return Column(
                  children: tournaments.map((tournament) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                      child: PremiumTournamentCard(
                        tournament: tournament,
                        title: tournament.nombre,
                        activityName: tournament.actividadNombre ?? 'Disciplina general',
                        schedule: '${tournament.fechaInicio ?? 'Pronto'} al ${tournament.fechaFin ?? 'Por definir'}',
                        accentColor: Colors.deepPurple,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: institutionalBlue),
                ),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Text('Error: ${err}', style: const TextStyle(color: AppTheme.dangerColor)),
              ),
            ),
            
            Builder(
              builder: (context) {
                final bool isMobile = MediaQuery.of(context).size.width < AppTheme.breakpointTablet;
                return SizedBox(height: isMobile ? 120 : 48);
              }
            ),
          ],
        ),
      ),
    );

    return MainLayout(
      activeIndex: 1, 
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Torneos Deportivos'),
          centerTitle: true,
        ),
        body: content,
      ),
    );
  }
}
