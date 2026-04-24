import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../models/tournament_model.dart';

final tournamentsProvider = StateNotifierProvider.autoDispose<TournamentsNotifier, AsyncValue<List<TournamentModel>>>((ref) {
  final apiClient = ref.watch(apiClientNotifierProvider);
  return TournamentsNotifier(apiClient);
});

class TournamentsNotifier extends StateNotifier<AsyncValue<List<TournamentModel>>> {
  final dynamic _apiClient;

  TournamentsNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    fetchTournaments();
  }

  Future<void> fetchTournaments() async {
    state = const AsyncValue.loading();
    if (_apiClient.token == null || _apiClient.token!.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    
    try {
      final response = await _apiClient.dio.get('arzsuite/torneos');
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }
      
      if (responseData['success'] == true) {
        final List<dynamic> data = responseData['data'];
        final tournaments = data.map((e) => TournamentModel.fromJson(e as Map<String, dynamic>)).toList();
        state = AsyncValue.data(tournaments);
      } else {
        state = AsyncError(responseData['message'] ?? 'Error desconocido', StackTrace.current);
      }
    } catch (e, st) {
      // Gracefully handle errors by returning an empty list instead of crashing UI
      state = const AsyncValue.data([]);
    }
  }

  Future<void> inscribirTorneo(int torneoId, int torneoEquipoId, String beneficiaryName, String beneficiarySocioId, bool isCaptain) async {
    try {
      final response = await _apiClient.dio.post('arzsuite/torneos/inscribir', data: {
        'torneo_id': torneoId,
        'torneo_equipo_id': torneoEquipoId,
        'beneficiary_name': beneficiaryName,
        'beneficiary_socio_id': beneficiarySocioId,
        'is_captain': isCaptain,
      });
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Error desconocido al inscribir');
      }
      
      await fetchTournaments();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
