import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../models/family_agenda_item.dart';

final familyAgendaProvider = FutureProvider.autoDispose<List<FamilyAgendaItem>>((ref) async {
  final apiClient = ref.watch(apiClientNotifierProvider);
  if (apiClient.token == null || apiClient.token!.isEmpty) {
    return [];
  }
  
  try {
    final response = await apiClient.dio.get('arzsuite/actividades/agenda-familiar');
    var responseData = response.data;
    if (responseData is String) {
      responseData = jsonDecode(responseData);
    }
    
    if (responseData['success'] == true) {
      final List<dynamic> data = responseData['data'];
      return data.map((e) => FamilyAgendaItem.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception(responseData['message'] ?? 'Error fetching agenda');
    }
  } catch (e) {
    // Gracefully fallback to an empty agenda instead of crashing the UI
    // print('Error fetching family agenda: $e');
    return [];
  }
});
