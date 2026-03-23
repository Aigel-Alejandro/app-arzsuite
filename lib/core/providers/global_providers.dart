import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

/// Proveedores de instancias y clientes que toda la app requiere de manera global.

// -----------------------------------------------------------------------------
// DIO / HTTP CLIENT
// -----------------------------------------------------------------------------
final apiClientProvider = Provider<ApiClient>((ref) {
  // Ajusta base URL al ambiente actual
  return ApiClient(baseUrl: ApiEndpoints.baseUrlCakePHP);
});

// -----------------------------------------------------------------------------
// WHATSAPP API CLIENT (YUPIO DELIVERY)
// -----------------------------------------------------------------------------
final whatsappClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiEndpoints.baseUrlWhatsApp,
    additionalHeaders: {
      'UserName': ApiEndpoints.whatsappUserName,
      'AuthenticationToken': ApiEndpoints.whatsappAuthToken,
    },
  );
});

// -----------------------------------------------------------------------------
// SUPABASE (Ejemplo, si existiera)
// -----------------------------------------------------------------------------
// final supabaseClientProvider = Provider<SupabaseClient>((ref) {
//   return Supabase.instance.client;
// });
