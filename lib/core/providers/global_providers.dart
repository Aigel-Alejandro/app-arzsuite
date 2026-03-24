import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'auth_provider.dart';

/// Proveedores de instancias y clientes que toda la app requiere de manera global.

// -----------------------------------------------------------------------------
// DIO / HTTP CLIENT
// -----------------------------------------------------------------------------
final apiClientProvider = Provider<ApiClient>((ref) {
  final user = ref.watch(authProvider);
  // Ajusta base URL al ambiente actual
  return ApiClient(
    baseUrl: ApiEndpoints.baseUrlCakePHP,
    token: user?.token,
  );
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
