import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/activity_subscription_view.dart';

class ActivitiesListView extends StatelessWidget {
  final bool isSubscribed;
  final bool useLayout;
  const ActivitiesListView({super.key, required this.isSubscribed, this.useLayout = true});

  @override
  Widget build(BuildContext context) {
    final body = Scaffold(
      backgroundColor: AppTheme.neutral50,
      appBar: AppBar(
        title: Text(isSubscribed ? 'Mis Actividades' : 'Actividades Disponibles'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingLarge),
              _ActivityCard(
                title: 'Fútbol Infantil (Sub-12)',
                instructor: 'Prof. Carlos Ramírez',
                spotsAvailable: isSubscribed ? null : 5,
                isSubscribed: isSubscribed,
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              _ActivityCard(
                title: 'Clase de Tenis',
                instructor: 'Prof. Ana López',
                spotsAvailable: isSubscribed ? null : 0,
                isSubscribed: isSubscribed,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );

    if (!useLayout) return body;
    return MainLayout(activeIndex: 1, child: body);
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String instructor;
  final int? spotsAvailable;
  final bool isSubscribed;

  const _ActivityCard({
    required this.title,
    required this.instructor,
    this.spotsAvailable,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    bool isFull = spotsAvailable == 0;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutral900,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isSubscribed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isFull ? AppTheme.neutral100 : AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Text(
                    isFull ? 'Agotado' : 'Cupo Limitado: $spotsAvailable',
                    style: TextStyle(
                      color: isFull ? AppTheme.neutral500 : AppTheme.successColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (isSubscribed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: const Text(
                    'Suscrito',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Row(
            children: [
              const Icon(Icons.person_rounded, size: 16, color: AppTheme.neutral500),
              const SizedBox(width: 4),
              Text(
                'Instructor: $instructor',
                style: const TextStyle(color: AppTheme.neutral600),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          if (!isSubscribed && !isFull)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => const ActivitySubscriptionView(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero),
                  );
                },
                child: const Text('Comenzar Inscripción', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          if (isSubscribed)
             SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Ver detalles o darse de baja
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMedium),
                ),
                child: const Text('Ver Detalles / Chats', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor)),
              ),
            ),
        ],
      ),
    );
  }
}
