import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers/global_providers.dart';

class SummerCourseService {
  final ApiClient _apiClient;

  SummerCourseService(this._apiClient);

  Future<List<Member>> getBeneficiaries(String titularId) async {
    try {
      final endpoint = ApiEndpoints.summerCourseFamily.replaceAll('{id}', titularId);
      final response = await _apiClient.dio.get(endpoint);
      
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        List<dynamic> listData = [];
        
        if (rawData is Map && rawData.containsKey('data')) {
          listData = rawData['data'] is List ? rawData['data'] : [];
        } else if (rawData is List) {
          listData = rawData;
        }
        
        return listData.map((json) {
          // Separar fullName en partes (el backend devuelve "1000301 NOMBRE APELLIDO")
          final fullName = (json['fullName'] ?? '').toString();
          // Quitar el número de acción si está prefijado (ej. "1000301 JOSE GARCIA")
          final nameParts = fullName.replaceFirst(RegExp(r'^\d+\s*'), '').trim().split(' ');
          final firstName = nameParts.isNotEmpty ? nameParts.first : fullName;
          final lastName = nameParts.length > 1 ? nameParts[1] : '';
          final secondLastName = nameParts.length > 2 ? nameParts.sublist(2).join(' ') : null;

          return Member(
            id: json['id']?.toString() ?? '',
            membershipNumber: json['membershipNumber']?.toString() ?? '',
            firstName: firstName,
            lastName: lastName,
            secondLastName: secondLastName,
            memberType: json['memberType']?.toString() ?? 'Dependiente',
            isTitular: json['isTitular'] == true,
            email: json['email']?.toString(),
            phone: json['phone']?.toString(),
            age: json['age'] as int?,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      if (e is DioException && e.response?.data != null && e.response?.data is Map) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> registrationData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.summerCourseRegister,
        data: registrationData,
      );
      
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            return rawData['data'] as Map<String, dynamic>;
        }
      }
      throw Exception('Respuesta inválida del servidor al registrar');
    } catch (e) {
      if (e is DioException && e.response?.data != null && e.response?.data is Map) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      rethrow;
    }
  }
}

final summerCourseServiceProvider = Provider<SummerCourseService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SummerCourseService(apiClient);
});
