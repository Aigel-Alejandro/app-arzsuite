import 'package:flutter/foundation.dart';

/// Archivo de Constantes Estructurales para conexiones con los sistemas de Backend de CakePHP
/// centraliza todas las validaciones de endpoints en un solo lugar.

class ApiEndpoints {
  // URLs Globales (Depende del ambiente de la app ej. Dev, Prod)
  static const String baseUrlCakePHP = kDebugMode 
      ? "https://ecosistema-centro.ddev.site/api/" // URL Desarrollo / Pruebas Local (DDEV)
      : "https://arzsuite.centrolibanes.org.mx/api/"; // URL Producción

  // ---------------------------------------------------------------------------
  // AUTH
  // ---------------------------------------------------------------------------
  static const String login = "auth/login";
  static const String loginSocio = "auth/login-socio";
  static const String requestSocioCode = "auth/request-socio-code";
  static const String loginAppCode = "auth/login-socio";
  static const String requestAppCode = "auth/request-socio-code";
  static const String logout = "auth/logout";
  static const String verifyToken = "auth/verify";
  static const String refreshSocio = "auth/refresh-socio";

  // ---------------------------------------------------------------------------
  // USUARIOS
  // ---------------------------------------------------------------------------
  static const String usersList = "/api/v1/users";
  static const String userDetail = "/api/v1/users/{id}"; // Interpolar ID en el repo

  // ---------------------------------------------------------------------------
  // ACTIVIDADES Y DEPORTES
  // ---------------------------------------------------------------------------
  static const String activitiesList = "/api/v1/activities";
  static const String activitiesSubscribed = "/api/v1/activities/subscribed";
  static const String activitySubscribe = "/api/v1/activities/{id}/subscribe";
  static const String activityChatMessages = "/api/v1/activities/chat/{channelId}/messages";
  static const String sendChatMessage = "/api/v1/activities/chat/{channelId}/send";
  static const String editChatMessage = "/api/v1/activities/chat/message/{id}";
  static const String readChatMessage = "/api/v1/activities/chat/message/{id}/read";
  static const String updateTrainingDates = "/api/v1/activities/training/{id}";
  static const String updateTournamentSchedule = "/api/v1/activities/tournament/{id}";
  
  // ---------------------------------------------------------------------------
  // TUTOR Y ALUMNO
  // ---------------------------------------------------------------------------
  static const String tutorBeneficiaries = "/api/v1/tutor/beneficiaries";
  static const String childProfileUpload = "/api/v1/child/documents/upload";
  
  // ---------------------------------------------------------------------------
  // CURSO DE VERANO
  // ---------------------------------------------------------------------------
  static const String summerCourseSearchTitular = "deportivo/summer-course/titular";
  static const String summerCourseRelationships = "deportivo/summer-course/relationships";
  static const String summerCourseFamily = "deportivo/summer-course/titular/{id}/family";
  static const String summerCourseGuest = "deportivo/summer-course/guest";
  static const String summerCourseRegister = "deportivo/summer-course/registration";
  
  // ---------------------------------------------------------------------------
  // TÉRMINOS Y CONDICIONES
  // ---------------------------------------------------------------------------
  static const String latestTerms = "/api/v1/terms/latest";
  static const String acceptTerms = "/api/v1/terms/accept";
  
  // ---------------------------------------------------------------------------
  // API WHATSAPP (YUPIO DELIVERY SERVICE)
  // --- Servicio externo para el envío de notificaciones por WhatsApp.
  // ---------------------------------------------------------------------------
  static const String baseUrlWhatsApp = "https://template-delivery-service.yupio.com.mx/api/v1/";
  static const String whatsappSend = "whatsapp/send";
  
  // Credenciales WhatsApp (Pruebas)
  static const String whatsappUserName = "CentroLibanesTest";
  static const String whatsappAuthToken = "0ad25924-8f6d-4c25-bd4f-f2615bffa589";
}
