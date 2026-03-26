import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'auth_provider.dart';
import 'api_client_notifier.dart';

/// Define un provider proxy que será inicializado (override) en el main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

/// Proveedores de instancias y clientes que toda la app requiere de manera global.

// -----------------------------------------------------------------------------
// DIO / HTTP CLIENT
// -----------------------------------------------------------------------------
final apiClientProvider = Provider<ApiClient>((ref) {
  // Usa el notifier mutable que permite actualizar el token en tiempo de ejecución
  return ref.watch(apiClientNotifierProvider);
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
