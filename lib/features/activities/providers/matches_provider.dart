import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../../../features/profile/providers/profile_provider.dart';
import '../models/match_model.dart';

final matchesProvider = StateNotifierProvider.autoDispose<MatchesNotifier, AsyncValue<List<MatchModel>>>((ref) {
  final apiClient = ref.watch(apiClientNotifierProvider);
  final profileState = ref.watch(profileProvider);
  final socioId = profileState.value?.socioId;

  return MatchesNotifier(apiClient, socioId);
});

class MatchesNotifier extends StateNotifier<AsyncValue<List<MatchModel>>> {
  final dynamic _apiClient;
  final int? _socioId;

  MatchesNotifier(this._apiClient, this._socioId) : super(const AsyncValue.loading()) {
    if (_socioId != null) {
      fetchMatches();
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> fetchMatches() async {
    state = const AsyncValue.loading();
    if (_apiClient.token == null || _apiClient.token!.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      final response = await _apiClient.dio.get(
        'arzsuite/actividades/mis-partidos',
        queryParameters: {'beneficiary_socio_id': _socioId},
      );
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }
      
      if (responseData['success'] == true) {
        final List<dynamic> data = responseData['data'] ?? [];
        final matches = data.map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
        state = AsyncValue.data(matches);
      } else {
        state = AsyncError(responseData['message'] ?? 'Error fetching matches', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> confirmAssistance(int convocatoriaId, String estado) async {
    try {
      final response = await _apiClient.dio.post('arzsuite/actividades/confirmar-asistencia', data: {
        'convocatoria_id': convocatoriaId,
        'estado': estado,
      });
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Hubo un error al guardar asistencia');
      }
      
      // Update local state smoothly
      if (state is AsyncData) {
        final currentMatches = state.value!;
        final updatedMatches = currentMatches.map((m) {
          if (m.convocatoriaId == convocatoriaId) {
            return MatchModel(
              convocatoriaId: m.convocatoriaId,
              partidoId: m.partidoId,
              torneoNombre: m.torneoNombre,
              equipoNuestro: m.equipoNuestro,
              equipoRival: m.equipoRival,
              fecha: m.fecha,
              lugar: m.lugar,
              esLocal: m.esLocal,
              golesLocal: m.golesLocal,
              golesVisitante: m.golesVisitante,
              estadoPartido: m.estadoPartido,
              estadoConfirmacion: estado,
            );
          }
          return m;
        }).toList();
        state = AsyncValue.data(updatedMatches);
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
