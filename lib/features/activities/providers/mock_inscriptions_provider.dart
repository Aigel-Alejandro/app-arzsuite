import 'package:flutter_riverpod/flutter_riverpod.dart';

class InscriptionsNotifier extends StateNotifier<Set<String>> {
  InscriptionsNotifier() : super({});

  void addInscription(String beneficiary, int activityId) {
    state = {...state, '$beneficiary-$activityId'};
  }

  bool isEnrolled(String beneficiary, int activityId) {
    return state.contains('$beneficiary-$activityId');
  }
}

final mockInscriptionsProvider = StateNotifierProvider<InscriptionsNotifier, Set<String>>((ref) {
  return InscriptionsNotifier();
});
