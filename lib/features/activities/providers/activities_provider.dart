import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../models/activity_model.dart';

final activitiesProvider = StateNotifierProvider.autoDispose<ActivitiesNotifier, AsyncValue<List<ActivityModel>>>((ref) {
  final apiClient = ref.watch(apiClientNotifierProvider);
  return ActivitiesNotifier(apiClient);
});

class ActivitiesNotifier extends StateNotifier<AsyncValue<List<ActivityModel>>> {
  final dynamic _apiClient;

  ActivitiesNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    state = const AsyncValue.loading();
    if (_apiClient.token == null || _apiClient.token!.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    
    try {
      final response = await _apiClient.dio.get('arzsuite/actividades');
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }
      
      if (responseData['success'] == true) {
        final List<dynamic> data = responseData['data'];
        final activities = data.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
        state = AsyncValue.data(activities);
      } else {
        state = AsyncError(responseData['message'] ?? 'Error desconocido', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> inscribirActividad(int equipoId, int? horarioId, String beneficiaryName, String beneficiarySocioId) async {
    try {
      final response = await _apiClient.dio.post('arzsuite/actividades/inscribir', data: {
        'equipo_id': equipoId,
        'horario_id': horarioId,
        'beneficiary_name': beneficiaryName,
        'beneficiary_socio_id': beneficiarySocioId,
      });
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Error desconocido al inscribir');
      }
      // Opcional: recargar el estado para reflejar el cupo tomado si es necesario
      await fetchActivities();
    } catch (e) {
      // Lanzar el error para que la UI lo atrape y muestre un Toast de Danger
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
