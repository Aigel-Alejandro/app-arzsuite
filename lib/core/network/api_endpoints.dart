/// Archivo de Constantes Estructurales para conexiones con los sistemas de Backend de CakePHP
/// centraliza todas las validaciones de endpoints en un solo lugar.

class ApiEndpoints {
  // URLs Globales (Depende del ambiente de la app ej. Dev, Prod)
  static const String baseUrlCakePHP = "https://arzsuite.centrolibanes.org.mx/api/"; // Eje central Sitio 2

  // ---------------------------------------------------------------------------
  // AUTH
  // ---------------------------------------------------------------------------
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String verifyToken = "auth/verify";

  // ---------------------------------------------------------------------------
  // USUARIOS
  // ---------------------------------------------------------------------------
  static const String usersList = "/api/v1/users";
  static const String userDetail = "/api/v1/users/{id}"; // Interpolar ID en el repo

  // ---------------------------------------------------------------------------
  // TODO: Agregar más módulos como se requiera a lo largo del desarrollo.
  // ---------------------------------------------------------------------------
}
