import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep;
            
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: isActive ? 6 : 4,
                decoration: BoxDecoration(
                  color: isCompleted || isActive
                      ? AppTheme.primaryColor
                      : AppTheme.neutral200,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Paso ${currentStep + 1} de $totalSteps',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '${((currentStep + 1) / totalSteps * 100).toInt()}% Completado',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.neutral500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

