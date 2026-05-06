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
    if (_apiClient.token == null || _apiClient.token!.isEmpty) {
      state = const AsyncValue.data(null);
      return;
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

  Future<void> addBeneficiary(String beneficiarySocioId) async {
    try {
      final response = await _apiClient.dio.post(
        'arzsuite/profile/addBeneficiary',
        data: {'beneficiary_socio_id': beneficiarySocioId},
      );
      if (response.data['success'] == true) {
        await fetchProfile(isBackgroundRefresh: true);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeBeneficiary(int id) async {
    try {
      final response = await _apiClient.dio.post(
        'arzsuite/profile/removeBeneficiary',
        data: {'id': id},
      );
      if (response.data['success'] == true) {
        await fetchProfile(isBackgroundRefresh: true);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addVehicle(Map<String, dynamic> vehicleData) async {
    try {
      final response = await _apiClient.dio.post(
        'arzsuite/profile/addVehicle',
        data: vehicleData,
      );
      if (response.data['success'] == true) {
        await fetchProfile(isBackgroundRefresh: true);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editVehicle(int id, Map<String, dynamic> vehicleData) async {
    try {
      vehicleData['id'] = id;
      final response = await _apiClient.dio.post(
        'arzsuite/profile/editVehicle',
        data: vehicleData,
      );
      if (response.data['success'] == true) {
        await fetchProfile(isBackgroundRefresh: true);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableVehicle(int id) async {
    try {
      final response = await _apiClient.dio.post(
        'arzsuite/profile/disableVehicle',
        data: {'id': id},
      );
      if (response.data['success'] == true) {
        await fetchProfile(isBackgroundRefresh: true);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFamilyMemberPermission(String memberId, String permission, bool isGranted) async {
    try {
      // Optimistic update
      if (state.value != null) {
        final profile = state.value!;
        final updatedMembers = profile.associatedMembers.map((m) {
          if (m.id == memberId) {
            final newPerms = List<String>.from(m.permissions);
            if (isGranted) {
              if (!newPerms.contains(permission)) newPerms.add(permission);
            } else {
              newPerms.remove(permission);
            }
            return m.copyWith(permissions: newPerms);
          }
          return m;
        }).toList();
        state = AsyncValue.data(profile.copyWith(associatedMembers: updatedMembers));
      }

      final response = await _apiClient.dio.post(
        'arzsuite/profile/updateFamilyPermission',
        data: {
          'member_id': memberId,
          'permission_key': permission,
          'is_granted': isGranted,
        },
      );
      
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      await fetchProfile(isBackgroundRefresh: true);
      rethrow;
    }
  }
}
