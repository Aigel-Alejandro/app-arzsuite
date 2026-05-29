import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/providers/global_providers.dart';

class SummerCourseService {
  final Ref _ref;

  SummerCourseService(this._ref);

  Future<List<Member>> getBeneficiaries(String titularId) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final endpoint = ApiEndpoints.summerCourseFamily.replaceAll('{id}', titularId);
      final response = await apiClient.dio.get(endpoint);
      
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
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        ApiEndpoints.summerCourseRegister,
        data: registrationData,
      );
      
      if ((response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 207) && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            return rawData['data'] as Map<String, dynamic>;
        }
      }
      throw Exception('Respuesta inválida del servidor al registrar (Status: ${response.statusCode})');
    } catch (e) {
      if (e is DioException && e.response?.data != null && e.response?.data is Map) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPickupToken(String userId) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.get(
        'deportivo/summer-course/pick-up-token',
        queryParameters: {
          'user_id': userId,
        },
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            return rawData['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getActiveRegistration(String userId) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.get(
        'deportivo/summer-course/active-registration',
        queryParameters: {
          'user_id': userId,
        },
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            return rawData['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  /// Verifica si hay un curso de verano activo (status = 'active').
  /// Retorna el mapa con [has_active_course] y [course], o null si hay error.
  Future<Map<String, dynamic>?> getActiveCourse() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.get(
        'deportivo/summer-course/active-course',
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
          return rawData['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCosts() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.get(
        'deportivo/summer-course/costs',
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            List<dynamic> listData = rawData['data'];
            return listData.map((e) => e as Map<String, dynamic>).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener costos: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getIntensiveActivities() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.get(
        'deportivo/summer-course/intensive-activities',
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            List<dynamic> listData = rawData['data'];
            return listData.map((e) => e as Map<String, dynamic>).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener actividades intensivas: $e');
      return [];
    }
  }

  Future<bool> updateIntensiveActivity(int participantId, int? activityId) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.patch(
        'deportivo/summer-course/update-intensive-activity/$participantId',
        data: {
          'intensive_activity_id': activityId,
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error al actualizar actividad intensiva: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> validateToken(String token) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        'deportivo/summer-course/validate-pick-up',
        data: {'token': token},
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data; // Includes participants and message
      }
      return null;
    } catch (e) {
      print('Error validando token: $e');
      return null;
    }
  }

  Future<bool> processAttendance(String token, String type) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        'deportivo/summer-course/process-attendance',
        data: {
          'token': token,
          'type': type, // 'check_in' or 'check_out'
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error en check in/out: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> generatePickupPass(int participantId, String authorizedName, bool canLeaveAlone, {String? photoBase64}) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        'deportivo/summer-course/pickup-pass',
        data: {
          'participant_id': participantId,
          'authorized_name': authorizedName,
          'can_leave_alone': canLeaveAlone,
          'photo_base64': photoBase64,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
            return rawData['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      if (e is DioException && e.response?.data != null && e.response?.data is Map) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> validatePickupPass(String token) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        'deportivo/summer-course/validate-pickup-pass',
        data: {'token': token},
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data; 
      }
      return null;
    } catch (e) {
      print('Error validando pickup pass: $e');
      return null;
    }
  }

  Future<bool> processPickupPass(String token) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.dio.post(
        'deportivo/summer-course/process-pickup-pass',
        data: {'token': token},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error procesando pickup pass: $e');
      return false;
    }
  }
}

final summerCourseServiceProvider = Provider<SummerCourseService>((ref) {
  return SummerCourseService(ref);
});
