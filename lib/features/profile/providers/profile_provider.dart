import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../models/profile_model.dart';
import '../models/profile_settings_model.dart';

final profileProvider = StateNotifierProvider.autoDispose<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  final apiClient = ref.watch(apiClientNotifierProvider);
  return ProfileNotifier(apiClient);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final dynamic _apiClient;

  ProfileNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile({bool isBackgroundRefresh = false}) async {
    if (!isBackgroundRefresh) {
      state = const AsyncValue.loading();
    }
    try {
      final response = await _apiClient.dio.get('arzsuite/profile');
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }
      
      if (responseData['success'] == true) {
        final profile = ProfileModel.fromJson(responseData['data']);
        state = AsyncValue.data(profile);
      } else {
        state = AsyncError(responseData['message'] ?? 'Error desconocido', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSettings(ProfileSettingsModel newSettings) async {
    try {
      final response = await _apiClient.dio.post(
        'arzsuite/profile/settings',
        data: newSettings.toJson(),
      );
      
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (responseData['success'] == true) {
        if (state.value != null) {
          state = AsyncValue.data(state.value!.copyWith(settings: newSettings));
        }
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido al actualizar');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? profilePictureBase64,
    Map<String, dynamic>? personalAddress,
    Map<String, dynamic>? fiscalData,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (profilePictureBase64 != null) {
        data['profile_picture'] = profilePictureBase64;
      }
      if (personalAddress != null) {
        data['personal_address'] = personalAddress;
      }
      if (fiscalData != null) {
        data['fiscal_data'] = fiscalData;
      }

      if (data.isEmpty) return;

      final response = await _apiClient.dio.post(
        'arzsuite/profile/update',
        data: data,
      );
      
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (responseData['success'] == true) {
        // Refresh silently without showing a loading spinner
        await fetchProfile(isBackgroundRefresh: true);
      } else {
        throw Exception(responseData['message'] ?? 'Error al actualizar perfil');
      }
    } catch (e) {
      rethrow;
    }
  }
}
