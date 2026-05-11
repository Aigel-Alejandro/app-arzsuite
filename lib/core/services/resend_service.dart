import 'package:dio/dio.dart';

class ResendService {
  static Future<bool> sendUpdateRequest({
    required String memberName,
    required String memberPhone,
    required String membershipNumber,
    required String requestType,
    required String details,
    required String memberEmail,
    required Dio dio,
  }) async {
    try {
      final response = await dio.post(
        '/socios/request-data-update',
        data: {
          'memberName': memberName,
          'memberPhone': memberPhone,
          'membershipNumber': membershipNumber,
          'requestType': requestType,
          'details': details,
          'memberEmail': memberEmail,
        },
      );

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      print('Error sending email update request via backend: $e');
      return false;
    }
  }
}
