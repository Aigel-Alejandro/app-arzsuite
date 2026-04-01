import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;
  String? _token;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? additionalHeaders,
    String? token,
  })  : _token = token,
        _dio = Dio(BaseOptions(
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
        if (_token != null && _token!.isNotEmpty) {
          final cleanToken = _token!.trim();
          options.headers['Authorization'] = 'Bearer $cleanToken';
          options.headers['X-Authorization'] = 'Bearer $cleanToken';
          // Debug log
          // ignore: avoid_print
          print('ApiClient: Adding Authorization headers with token: $cleanToken');
        } else {
          // ignore: avoid_print
          print('ApiClient: No token set for request to ${options.path}');
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

    if (kDebugMode) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
  }

  // Method to update token after login
  void updateToken(String token) {
    _token = token;
  }

  Dio get dio => _dio;
  String? get token => _token;
}
