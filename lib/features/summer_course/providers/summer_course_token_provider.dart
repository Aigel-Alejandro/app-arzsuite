import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/summer_course_service.dart';
import '../../../core/providers/auth_provider.dart';

final summerCourseTokenProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authProvider);
  if (user == null) return null;

  final service = ref.read(summerCourseServiceProvider);
  try {
    return await service.getPickupToken(user.id);
  } catch (e) {
    return null;
  }
});
