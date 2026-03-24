import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/summer_course_state.dart';
import 'package:app_arzsuite/features/summer_course/widgets/step_indicator.dart';
import 'package:app_arzsuite/features/summer_course/views/steps/step2_beneficiaries.dart';
import 'package:app_arzsuite/features/summer_course/views/steps/step3_guests.dart';
import 'package:app_arzsuite/features/summer_course/views/steps/step4_weeks.dart';
import 'package:app_arzsuite/features/summer_course/views/steps/step5_confirmation.dart';

class SummerCourseWizardView extends ConsumerWidget {
  const SummerCourseWizardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);

    // Escuchar errores y mostrarlos
    ref.listen<SummerCourseState>(summerCourseProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.dangerColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return MainLayout(
      activeIndex: -1,
      child: Scaffold(
        backgroundColor: AppTheme.neutral50,
      body: SafeArea(
        child: ResponsiveContainer(
          padding: 0,
          child: Column(
            children: [
              // Custom Integrated Header
              Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 20),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppTheme.neutral900),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Expanded(
                          child: Text(
                            'Inscripción 2026',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.neutral900,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance the back button
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StepIndicator(
                        currentStep: state.currentStep > 3 ? 3 : state.currentStep, 
                        totalSteps: 4
                      ),
                    ),
                  ],
                ),
              ),
              
              // Current Step Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(state.currentStep),
                    child: _buildCurrentStep(state.currentStep),
                  ),
                ),
              ),
              
              // Navigation Buttons
              _buildNavigation(context, state, notifier),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildCurrentStep(int step) {
    switch (step) {
      case 0: return const Step2Beneficiaries();
      case 1: return const Step3Guests();
      case 2: return const Step4Weeks();
      case 3: return const Step5Confirmation();
      default: return const Step2Beneficiaries();
    }
  }

  Widget _buildNavigation(BuildContext context, SummerCourseState state, SummerCourseNotifier notifier) {
    if (state.salesOrderId != null) return const SizedBox.shrink(); // No nav in success state
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppTheme.spacingLarge,
        AppTheme.spacingMedium,
        AppTheme.spacingLarge,
        MediaQuery.of(context).padding.bottom + AppTheme.spacingMedium,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          // Back button
          if (state.currentStep > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: state.isLoading ? null : () => notifier.previousStep(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.neutral200),
                  foregroundColor: AppTheme.neutral600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Anterior', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          else
            const SizedBox.shrink(),

          if (state.currentStep > 0) const SizedBox(width: 16),
          
          // Next button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: (_isNextDisabled(state) || state.isLoading)
                  ? null 
                  : (state.currentStep == 3 ? () => notifier.submitRegistration() : () => notifier.nextStep()),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: AppTheme.neutral200,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.isLoading && state.currentStep == 3
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      state.currentStep == 3 ? 'Generar Orden de Venta' : 'Continuar',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isNextDisabled(SummerCourseState state) {
    if (state.currentStep == 0) return state.selectedParticipants.isEmpty;
    if (state.currentStep == 1) return state.selectedParticipants.isEmpty; // Al menos un participante (socio o invitado)
    if (state.currentStep == 2) {
      if (state.selectedParticipants.isEmpty) return true;
      return state.selectedParticipants.any((p) => p.selectedWeekIds.isEmpty);
    }
    return false;
  }
}

