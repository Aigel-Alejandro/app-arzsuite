import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';

/// Proveedor para inyectar (dependencias/estados) nuestro ApiClient globalmente
/// Riverpod se utiliza para la "inyección de dependencias" y "gestión del estado".
final apiClientProvider = Provider<ApiClient>((ref) {
  // Configura con la url (IP/dominio) del endpoint de CakePHP 5
  return ApiClient(baseUrl: 'https://tu-endpoint-cakephp5.com/api'); 
});
