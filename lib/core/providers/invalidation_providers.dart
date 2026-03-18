import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centraliza los proveedores de la aplicación que interactúan globalmente.
/// Estas dependencias se utilizan a menudo para desencadenar recargas / re-renders.

// -----------------------------------------------------------------------------
// EVENTOS EXTERNOS / INVALIDACIÓN DE CACHÉ Y ESTADOS
// -----------------------------------------------------------------------------

/// Provider para capturar e invalidar el estado general de Autenticación de la App.
/// Se usa principalmente para limpiar todos los repos de datos del usuario al hacer Logout o token inválido.
final sessionInvalidationProvider = Provider<void>((ref) {
  // Lógica de reseteo, Ej: ref.invalidate(userRepositoryProvider), etc.
});

// -----------------------------------------------------------------------------
// CONTROLADOR GLOBAL PARA FORZAR DESTRUCCIÓN DE INSTANCIAS (CLEAN MEMORIAS)
// -----------------------------------------------------------------------------
void clearApplicationState(Ref ref) {
  /// Al desloguearse o presentarse alguna brecha, aquí mandamos purgar a Riverpod
  /// de forma masiva sobre distintos controladores, Ej: ref.invalidate() a otros stores
  ref.invalidate(activitiesCacheProvider);
  ref.invalidate(chatCacheProvider);
}

// -----------------------------------------------------------------------------
// INVALIDACIÓN POR MÓDULOS (RIVERPOD)
// -----------------------------------------------------------------------------

final activitiesCacheProvider = Provider<void>((ref) {
  // Dispara el refresco de los repositorios de Actividades
});

final chatCacheProvider = Provider<void>((ref) {
  // Dispara la recarga de la lista de chats
});
