import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/summer_course_service.dart';

/// Provider que consulta si hay un curso de verano activo en el sistema.
/// La UI usa esto para decidir si mostrar o no la sección de inscripción.
/// Retorna el mapa completo con {has_active_course, course} o null en error.
final activeSummerCourseProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final service = ref.read(summerCourseServiceProvider);
  return await service.getActiveCourse();
});
