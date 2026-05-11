import 'package:dio/dio.dart';

class ResendService {
  static const String _apiKey = 're_3BgqacJs_MRTRND3Lc5kBGj5Bt1Z5cDoB';
  static const String _apiUrl = 'https://api.resend.com/emails';

  static Future<bool> sendUpdateRequest({
    required String memberName,
    required String memberPhone,
    required String membershipNumber,
    required String requestType,
    required String details,
    required String memberEmail,
  }) async {
    try {
      final dio = Dio();
      
      final htmlContent = '''
        <h2>Solicitud de Actualización de Datos</h2>
        <p><strong>Socio:</strong> $memberName</p>
        <p><strong>Número de Socio:</strong> $membershipNumber</p>
        <p><strong>Teléfono:</strong> $memberPhone</p>
        <p><strong>Email:</strong> $memberEmail</p>
        <hr />
        <p><strong>Tipo de Solicitud:</strong> $requestType</p>
        <p><strong>Detalles:</strong></p>
        <p>$details</p>
      ''';

      final response = await dio.post(
        _apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'from': 'App Centro Libanés <soporte@arzsuite.centrolibanes.org.mx>',
          'to': ['cobranza@centrolibanes.org.mx'],
          'subject': 'Solicitud de Actualización de Datos - Socio $membershipNumber',
          'html': htmlContent,
          'reply_to': memberEmail,
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error sending email via Resend: $e');
      return false;
    }
  }
}
