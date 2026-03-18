import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/summer_course_state.dart';
import 'package:app_arzsuite/features/summer_course/widgets/step_indicator.dart';
import 'package:app_arzsuite/features/summer_course/views/steps/step1_search_titular.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscripción Curso de Verano'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: StepIndicator(currentStep: state.currentStep, totalSteps: 5),
          ),
          
          // Current Step Content
          Expanded(
            child: _buildCurrentStep(state.currentStep),
          ),
          
          // Navigation Buttons
          _buildNavigation(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(int step) {
    switch (step) {
      case 0: return const Step1SearchTitular();
      case 1: return const Step2Beneficiaries();
      case 2: return const Step3Guests();
      case 3: return const Step4Weeks();
      case 4: return const Step5Confirmation();
      default: return const Step1SearchTitular();
    }
  }

  Widget _buildNavigation(BuildContext context, SummerCourseState state, SummerCourseNotifier notifier) {
    if (state.currentStep == 4) return const SizedBox.shrink(); // No nav in step 5 result
    
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (state.currentStep > 0)
            OutlinedButton(
              onPressed: () => notifier.previousStep(),
              child: const Text('Anterior'),
            )
          else
            const SizedBox.shrink(),

          // Next button
          ElevatedButton(
            onPressed: _isNextDisabled(state) ? null : () => notifier.nextStep(),
            child: Text(state.currentStep == 3 ? 'Confirmar' : 'Siguiente'),
          ),
        ],
      ),
    );
  }

  bool _isNextDisabled(SummerCourseState state) {
    if (state.currentStep == 0) return state.selectedTitular == null;
    if (state.currentStep == 1) return false; // Paso 2 y 3 son combinados para validar 1 participante
    if (state.currentStep == 2) return state.selectedParticipants.isEmpty;
    if (state.currentStep == 3) {
      // All participants must have at least one week
      if (state.selectedParticipants.isEmpty) return true;
      return state.selectedParticipants.any((p) => p.selectedWeekIds.isEmpty);
    }
    return false;
  }
}
