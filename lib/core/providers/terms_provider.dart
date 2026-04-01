import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/api_client_notifier.dart';

class TerminosModel {
  final int id;
  final int version;
  final String contenido;
  final String modulo;

  TerminosModel({
    required this.id,
    required this.version,
    required this.contenido,
    required this.modulo,
  });

  factory TerminosModel.fromJson(Map<String, dynamic> json) {
    return TerminosModel(
      id: json['id'],
      version: json['version'],
      contenido: json['contenido'],
      modulo: json['modulo'],
    );
  }
}

class TermsStatus {
  final bool required;
  final bool accepted;
  final TerminosModel? terminos;

  TermsStatus({
    required this.required,
    required this.accepted,
    this.terminos,
  });
}

final termsProvider = Provider<TermsService>((ref) {
  return TermsService(ref.watch(apiClientNotifierProvider));
});

class TermsService {
  final dynamic _apiClient;

  TermsService(this._apiClient);

  Future<TermsStatus> checkTerms(String modulo) async {
    try {
      final response = await _apiClient.dio.get('arzsuite/terminos-condiciones/check', queryParameters: {'modulo': modulo});
      var data = response.data;
      if (data is String) data = jsonDecode(data);

      if (data['success'] == true) {
        final d = data['data'];
        TerminosModel? t;
        if (d['terminos'] != null) {
          t = TerminosModel.fromJson(d['terminos']);
        }
        return TermsStatus(
          required: d['required'] ?? false,
          accepted: d['accepted'] ?? false,
          terminos: t,
        );
      }
      return TermsStatus(required: false, accepted: false);
    } catch (e) {
      return TermsStatus(required: false, accepted: false);
    }
  }

  Future<bool> acceptTerms(String modulo, int version, int terminosId) async {
    try {
      final response = await _apiClient.dio.post('arzsuite/terminos-condiciones/accept', data: {
        'modulo': modulo,
        'version': version,
        'terminos_id': terminosId,
      });
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
