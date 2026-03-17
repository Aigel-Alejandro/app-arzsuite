/// Archivo de Constantes Estructurales para conexiones con los sistemas de Backend de CakePHP
/// centraliza todas las validaciones de endpoints en un solo lugar.

class ApiEndpoints {
  // URLs Globales (Depende del ambiente de la app ej. Dev, Prod)
  static const String baseUrlCakePHP = "http://centro.ddev.site/"; // Ajustar acorde al entorno.

  // ---------------------------------------------------------------------------
  // AUTH
  // ---------------------------------------------------------------------------
  static const String login = "/api/v1/auth/login";
  static const String logout = "/api/v1/auth/logout";
  static const String verifyToken = "/api/v1/auth/verify";

  // ---------------------------------------------------------------------------
  // USUARIOS
  // ---------------------------------------------------------------------------
  static const String usersList = "/api/v1/users";
  static const String userDetail = "/api/v1/users/{id}"; // Interpolar ID en el repo

  // ---------------------------------------------------------------------------
  // TODO: Agregar más módulos como se requiera a lo largo del desarrollo.
  // ---------------------------------------------------------------------------
}
