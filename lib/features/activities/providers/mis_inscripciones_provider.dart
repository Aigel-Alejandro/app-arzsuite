import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../models/inscripcion_model.dart';

// ── Provider ─────────────────────────────────────────────────────────────────
final misInscripcionesProvider =
    StateNotifierProvider.autoDispose<
      MisInscripcionesNotifier,
      AsyncValue<List<InscripcionModel>>
    >((ref) {
      final apiClient = ref.watch(apiClientNotifierProvider);
      return MisInscripcionesNotifier(apiClient);
    });

class MisInscripcionesNotifier
    extends StateNotifier<AsyncValue<List<InscripcionModel>>> {
  final dynamic _apiClient;

  MisInscripcionesNotifier(this._apiClient)
    : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch({String? beneficiarySocioId}) async {
    state = const AsyncValue.loading();
    if (_apiClient.token == null || _apiClient.token!.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      final queryParams = <String, dynamic>{};
      if (beneficiarySocioId != null) {
        queryParams['beneficiary_socio_id'] = beneficiarySocioId;
      }
      final response = await _apiClient.dio.get(
        'arzsuite/actividades/mis-actividades',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data['success'] == true) {
        final list = (data['data'] as List)
            .map((e) => InscripcionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        state = AsyncValue.data(list);
      } else {
        state = AsyncError(data['message'] ?? 'Error', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelar(int inscripcionId) async {
    try {
      final response = await _apiClient.dio.post(
        'arzsuite/actividades/cancelar-inscripcion',
        data: {'inscripcion_id': inscripcionId},
      );
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Error al cancelar');
      }
      await fetch();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
