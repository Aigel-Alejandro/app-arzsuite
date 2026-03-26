import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'global_providers.dart';

/// Notifier que mantiene una instancia mutable de ApiClient.
/// Permite actualizar el token JWT después del login sin crear una nueva instancia.
class ApiClientNotifier extends StateNotifier<ApiClient> {
  ApiClientNotifier(String? initialToken)
      : super(ApiClient(
          baseUrl: ApiEndpoints.baseUrlCakePHP,
          token: initialToken,
        ));

  /// Actualiza el token y emite una NUEVA instancia de ApiClient para notificar a Riverpod.
  void updateToken(String token) {
    state = ApiClient(
      baseUrl: state.baseUrl,
      token: token,
    );
  }
}

/// Provider que expone el notifier para que pueda ser usado en cualquier parte del app.
final apiClientNotifierProvider =
    StateNotifierProvider<ApiClientNotifier, ApiClient>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final token = prefs.getString('saved_token');
  return ApiClientNotifier(token);
});
