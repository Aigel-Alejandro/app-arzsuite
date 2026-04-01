import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/api_client_notifier.dart';
import '../models/sat_catalogs_model.dart';
import 'package:flutter/foundation.dart';

final satCatalogsProvider = FutureProvider<SatCatalogsModel?>((ref) async {
  final apiClient = ref.watch(apiClientNotifierProvider);
  if (apiClient.token == null || apiClient.token!.isEmpty) {
    return null;
  }
  
  try {
    final response = await apiClient.dio.get('/catalogs/sat');
    if (response.statusCode == 200 && response.data != null) {
      if (response.data['success'] == true) {
        return SatCatalogsModel.fromJson(response.data);
      }
    }
  } catch (e) {
    debugPrint('Error fetching SAT Catalogs: $e');
  }
  return null;
});
