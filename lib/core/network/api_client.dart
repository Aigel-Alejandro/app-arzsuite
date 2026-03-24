import 'package:dio/dio.dart';

/// Cliente API para consumir el backend externo de CakePHP 5 (centro-backend)
class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    Map<String, String>? additionalHeaders,
    String? token,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...?additionalHeaders,
          },
        )) {
    // Interceptores para manejo de tokens, logging, etc.
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Manejar errores de red, respuestas 401, etc.
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
