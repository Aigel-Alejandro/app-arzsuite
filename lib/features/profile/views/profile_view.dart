import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../../../core/widgets/main_layout.dart';
import '../../auth/views/login_view.dart';
import '../providers/profile_provider.dart';
import '../models/profile_model.dart';
import '../models/sub_member_model.dart';
import '../../../core/providers/sat_catalogs_provider.dart';
import '../../../core/models/sat_catalogs_model.dart';
import 'health_view.dart';
import '../../../core/widgets/custom_premium_app_bar.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import '../../../core/services/resend_service.dart';
import 'package:intl/intl.dart';

final userPaymentsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientNotifierProvider);
  if (apiClient.token == null || apiClient.token!.isEmpty) {
    return <String, dynamic>{};
  }
  final response = await apiClient.dio.get('/deportivo/payments/my-payments');
  if (response.statusCode == 200 && response.data['success'] == true) {
    return response.data['data'] as Map<String, dynamic>;
  }
  throw Exception('No se pudieron obtener las finanzas');
});

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final ImagePicker _picker = ImagePicker();

  bool _isSearchingCp = false;
  String? _lastSearchedCp;

  // Controllers Flag
  bool _isInit = false;

  // Address Controllers
  final TextEditingController _streetCtrl = TextEditingController();
  final TextEditingController _extNumCtrl = TextEditingController();
  final TextEditingController _intNumCtrl = TextEditingController();
  final TextEditingController _coloniaCtrl = TextEditingController();
  final TextEditingController _ciudadCtrl = TextEditingController();
  final TextEditingController _estadoCtrl = TextEditingController();
  final TextEditingController _cpCtrl = TextEditingController();

  // Fiscal Controllers
  final TextEditingController _rfcCtrl = TextEditingController();
  final TextEditingController _razonSocialCtrl = TextEditingController();
  final TextEditingController _regimenCtrl = TextEditingController();
  final TextEditingController _usoCfdiCtrl = TextEditingController();

  // Fiscal Address Controllers
  bool _isSameAddress = true;
  final TextEditingController _fiscalStreetCtrl = TextEditingController();
  final TextEditingController _fiscalExtNumCtrl = TextEditingController();
  final TextEditingController _fiscalIntNumCtrl = TextEditingController();
  final TextEditingController _fiscalColoniaCtrl = TextEditingController();
  final TextEditingController _fiscalCiudadCtrl = TextEditingController();
  final TextEditingController _fiscalEstadoCtrl = TextEditingController();
  final TextEditingController _fiscalCpCtrl = TextEditingController();
  String? _lastSearchedFiscalCp;

  @override
  void initState() {
    super.initState();
    _cpCtrl.addListener(() => _onCpChanged(false));
    _fiscalCpCtrl.addListener(() => _onCpChanged(true));
  }

  void _onCpChanged(bool isFiscal) {
    final ctrl = isFiscal ? _fiscalCpCtrl : _cpCtrl;
    final lastSearched = isFiscal ? _lastSearchedFiscalCp : _lastSearchedCp;
    final cp = ctrl.text.trim();
    if (cp.length == 5 && int.tryParse(cp) != null && cp != lastSearched) {
      _fetchAddressByCp(cp, isFiscal);
    }
  }

  Future<void> _fetchAddressByCp(String cp, bool isFiscal) async {
    if (!mounted) return;
    setState(() => _isSearchingCp = true);
    if (isFiscal) {
      _lastSearchedFiscalCp = cp;
    } else {
      _lastSearchedCp = cp;
    }

    try {
      final dio = Dio();
      const apiKey = 'AIzaSyBAHAj21BJ9bkYfA8GlUsJdglNtCTl63kA';
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'components': 'postal_code:$cp|country:MX',
          'key': apiKey,
          'language': 'es',
        },
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final result = data['results'][0] as Map<String, dynamic>;
          final components = result['address_components'] as List<dynamic>? ?? [];
          
          String estado = '';
          String ciudad = '';
          String coloniaSola = '';

          for (var comp in components) {
            final types = comp['types'] as List<dynamic>? ?? [];
            if (types.contains('administrative_area_level_1')) {
              estado = comp['long_name'];
            }
            // Locality means City, administrative_area_level_2 means Municipality
            if (types.contains('locality') || types.contains('administrative_area_level_2')) {
              ciudad = comp['long_name'];
            }
            if (types.contains('sublocality') || types.contains('neighborhood') || types.contains('sublocality_level_1')) {
              coloniaSola = comp['long_name'];
            }
          }
          
          if (!mounted) return;
          setState(() {
            if (isFiscal) {
              if (estado.isNotEmpty) _fiscalEstadoCtrl.text = estado;
              _fiscalCiudadCtrl.text = ciudad.isNotEmpty ? ciudad : estado;
            } else {
              if (estado.isNotEmpty) _estadoCtrl.text = estado;
              _ciudadCtrl.text = ciudad.isNotEmpty ? ciudad : estado;
            }
          });

          // Google sometimes provides an array of localities inside the postal code area
          final localities = result['postcode_localities'] as List<dynamic>?;
          
          if (localities != null && localities.isNotEmpty) {
            final colonias = localities.map((e) => e.toString()).toList();
            if (colonias.length == 1) {
               setState(() {
                 if (isFiscal) {
                   _fiscalColoniaCtrl.text = colonias[0];
                 } else {
                   _coloniaCtrl.text = colonias[0];
                 }
               });
            } else {
               _showColoniaSelector(colonias, isFiscal);
            }
          } else if (coloniaSola.isNotEmpty) {
            setState(() {
              if (isFiscal) {
                _fiscalColoniaCtrl.text = coloniaSola;
              } else {
                _coloniaCtrl.text = coloniaSola;
              }
            });
          }
        } else {
          throw Exception('No result geometry found');
        }
      }
    } catch (e) {
      debugPrint('Error fetching CP with Google Maps: $e');
      if (!mounted) return;
      ToastAlerts.showWarning(context, 'No se encontró información extra para este código postal.');
    } finally {
      if (mounted) {
        setState(() => _isSearchingCp = false);
      }
    }
  }

  void _showColoniaSelector(List<String> colonias, bool isFiscal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Selecciona tu Colonia',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: colonias.length,
                  itemBuilder: (context, index) {
                    final colonia = colonias[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(colonia),
                      leading: const Icon(Icons.location_city_rounded, color: AppTheme.primaryColor),
                      onTap: () {
                        setState(() {
                          if (isFiscal) {
                            _fiscalColoniaCtrl.text = colonia;
                          } else {
                            _coloniaCtrl.text = colonia;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGenericSelector(String title, List<String> options, TextEditingController controller, IconData icon) {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                final filteredOptions = options.where((o) => 
                  o.toLowerCase().contains(searchQuery.toLowerCase())
                ).toList();

                return Container(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Escribe para buscar...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filteredOptions.length,
                          itemBuilder: (context, index) {
                            final option = filteredOptions[index];
                            final isSelected = controller.text == option;
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                              title: Text(
                                option, 
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppTheme.primaryColor : null,
                                )
                              ),
                              leading: Icon(
                                icon, 
                                color: isSelected ? AppTheme.primaryColor : AppTheme.neutral400
                              ),
                              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor) : null,
                              onTap: () {
                                setState(() {
                                  controller.text = option;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _extNumCtrl.dispose();
    _intNumCtrl.dispose();
    _coloniaCtrl.dispose();
    _ciudadCtrl.dispose();
    _estadoCtrl.dispose();
    _cpCtrl.dispose();
    _rfcCtrl.dispose();
    _razonSocialCtrl.dispose();
    _regimenCtrl.dispose();
    _usoCfdiCtrl.dispose();
    
    _fiscalStreetCtrl.dispose();
    _fiscalExtNumCtrl.dispose();
    _fiscalIntNumCtrl.dispose();
    _fiscalColoniaCtrl.dispose();
    _fiscalCiudadCtrl.dispose();
    _fiscalEstadoCtrl.dispose();
    _fiscalCpCtrl.dispose();
    super.dispose();
  }

  void _onLogout() {
    ref.read(authProvider.notifier).logout();
    ref.read(apiClientNotifierProvider.notifier).updateToken('');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  Future<void> _onEditPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
      );
      
      if (image == null) return;

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final dataUri = 'data:image/${image.name.split('.').last};base64,$base64Image';

      if (!mounted) return;
      
      // Mostrar feedback de carga
      ToastAlerts.showWarning(context, 'Subiendo foto de perfil...');

      await ref.read(profileProvider.notifier).updateProfile(
        profilePictureBase64: dataUri,
      );

      if (!mounted) return;
      ToastAlerts.showSuccess(context, 'Foto de perfil actualizada');
    } catch (e) {
      if (!mounted) return;
      ToastAlerts.showError(context, 'Error al subir la foto: $e');
    }
  }

  void _initControllers(ProfileModel profile) {
    if (_isInit) return;
    
    final personalAddress = profile.personalAddress ?? {};
    _streetCtrl.text = personalAddress['street'] ?? '';
    _extNumCtrl.text = personalAddress['ext_number'] ?? '';
    _intNumCtrl.text = personalAddress['int_number'] ?? '';
    _coloniaCtrl.text = personalAddress['neighborhood'] ?? '';
    _ciudadCtrl.text = personalAddress['city'] ?? '';
    _estadoCtrl.text = personalAddress['state'] ?? '';
    final initialCp = personalAddress['zip_code'] ?? '';
    _lastSearchedCp = initialCp;
    _cpCtrl.text = initialCp;

    final fiscalData = profile.fiscalData ?? {};
    _rfcCtrl.text = fiscalData['rfc'] ?? profile.rfc ?? '';
    _razonSocialCtrl.text = fiscalData['business_name'] ?? '';
    _regimenCtrl.text = fiscalData['tax_regime'] ?? '';
    _usoCfdiCtrl.text = fiscalData['cfdi_use'] ?? '';
    
    _isSameAddress = fiscalData['is_same_address'] ?? true;
    _fiscalStreetCtrl.text = fiscalData['street'] ?? '';
    _fiscalExtNumCtrl.text = fiscalData['ext_number'] ?? '';
    _fiscalIntNumCtrl.text = fiscalData['int_number'] ?? '';
    _fiscalColoniaCtrl.text = fiscalData['neighborhood'] ?? '';
    _fiscalCiudadCtrl.text = fiscalData['city'] ?? '';
    _fiscalEstadoCtrl.text = fiscalData['state'] ?? '';
    final initialFiscalCp = fiscalData['zip_code'] ?? '';
    _lastSearchedFiscalCp = initialFiscalCp;
    _fiscalCpCtrl.text = initialFiscalCp;

    _isInit = true;
  }

  Future<void> _saveAddress(ProfileModel profile) async {
    final updatedAddress = Map<String, dynamic>.from(profile.personalAddress ?? {});
    updatedAddress['street'] = _streetCtrl.text.trim();
    updatedAddress['ext_number'] = _extNumCtrl.text.trim();
    updatedAddress['int_number'] = _intNumCtrl.text.trim();
    updatedAddress['neighborhood'] = _coloniaCtrl.text.trim();
    updatedAddress['city'] = _ciudadCtrl.text.trim();
    updatedAddress['state'] = _estadoCtrl.text.trim();
    updatedAddress['zip_code'] = _cpCtrl.text.trim();
    
    try {
      await ref.read(profileProvider.notifier).updateProfile(personalAddress: updatedAddress);
      if (!mounted) return;
      ToastAlerts.showSuccess(context, 'Dirección actualizada');
    } catch (e) {
      if (!mounted) return;
      ToastAlerts.showError(context, 'Error: $e');
    }
  }

  Future<void> _saveFiscalData(ProfileModel profile) async {
    final updatedFiscal = Map<String, dynamic>.from(profile.fiscalData ?? {});
    updatedFiscal['rfc'] = _rfcCtrl.text.trim();
    updatedFiscal['business_name'] = _razonSocialCtrl.text.trim();
    updatedFiscal['tax_regime'] = _regimenCtrl.text.trim();
    updatedFiscal['cfdi_use'] = _usoCfdiCtrl.text.trim();
    
    updatedFiscal['is_same_address'] = _isSameAddress;
    if (!_isSameAddress) {
      updatedFiscal['street'] = _fiscalStreetCtrl.text.trim();
      updatedFiscal['ext_number'] = _fiscalExtNumCtrl.text.trim();
      updatedFiscal['int_number'] = _fiscalIntNumCtrl.text.trim();
      updatedFiscal['neighborhood'] = _fiscalColoniaCtrl.text.trim();
      updatedFiscal['city'] = _fiscalCiudadCtrl.text.trim();
      updatedFiscal['state'] = _fiscalEstadoCtrl.text.trim();
      updatedFiscal['zip_code'] = _fiscalCpCtrl.text.trim();
    } else {
      updatedFiscal['street'] = _streetCtrl.text.trim();
      updatedFiscal['ext_number'] = _extNumCtrl.text.trim();
      updatedFiscal['int_number'] = _intNumCtrl.text.trim();
      updatedFiscal['neighborhood'] = _coloniaCtrl.text.trim();
      updatedFiscal['city'] = _ciudadCtrl.text.trim();
      updatedFiscal['state'] = _estadoCtrl.text.trim();
      updatedFiscal['zip_code'] = _cpCtrl.text.trim();
    }
    
    try {
      await ref.read(profileProvider.notifier).updateProfile(fiscalData: updatedFiscal);
      if (!mounted) return;
      ToastAlerts.showSuccess(context, 'Datos fiscales actualizados');
    } catch (e) {
      if (!mounted) return;
      ToastAlerts.showError(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final currentMember = ref.watch(authProvider);
    ref.watch(satCatalogsProvider); // Trigger catalog fetch early

    return MainLayout(
      activeIndex: 2,
      child: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Perfil no encontrado'));
          }
          
          if (!_isInit) _initControllers(profile);

          return RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.surface,
            color: AppTheme.primaryColor,
            onRefresh: () async {
              _isInit = false;
              await ref.read(profileProvider.notifier).fetchProfile(isBackgroundRefresh: true);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, 32, AppTheme.spacingLarge, 100),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mi Perfil',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.white,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.sync_rounded),
                        color: AppTheme.primaryColor,
                        tooltip: 'Actualizar perfil',
                        onPressed: () async {
                          _isInit = false;
                          await ref.read(profileProvider.notifier).fetchProfile(isBackgroundRefresh: true);
                          if (context.mounted) {
                            ToastAlerts.showSuccess(context, 'Verificando permisos de edición...');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildProfileHero(context, profile),
                const SizedBox(height: 24),
                GridView.count(
                  key: const ValueKey('profile_premium_grid'),
                  padding: EdgeInsets.zero,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.15,
                  children: [
                    _buildPremiumMenuTile(
                      context,
                      icon: Icons.person_rounded,
                      title: 'Membresía',
                      onTap: () => _navigateToSection(context, 'Membresía', 'Información de tu cuenta', Icons.person_outline_rounded, (ctx, r, p) => _buildAccountTab(ctx, r, p)),
                    ),
                    _buildPremiumMenuTile(
                      context,
                      icon: Icons.settings_rounded,
                      title: 'Ajustes de la App',
                      onTap: () => _navigateToSection(context, 'Ajustes', 'Preferencias de la aplicación', Icons.settings_outlined, (ctx, r, p) => _buildSettingsTab(ctx, r, p)),
                    ),
                    if (currentMember?.hasPermission('profile.associated_members') ?? false)
                      _buildPremiumMenuTile(
                        context,
                        icon: Icons.family_restroom_rounded,
                        title: 'Beneficiarios Legales',
                        onTap: () => _navigateToSection(context, 'Beneficiarios', 'Gestión de dependientes', Icons.family_restroom_rounded, (ctx, r, p) => _buildBeneficiariesTab(ctx, p)),
                      ),
                    if (currentMember?.hasPermission('profile.vehicles') ?? false)
                      _buildPremiumMenuTile(
                        context,
                        icon: Icons.directions_car_rounded,
                        title: 'Registro de Vehículos',
                        onTap: () => _navigateToSection(context, 'Mis Vehículos', 'Solo 1 auto permitido por acceso', Icons.directions_car_outlined, (ctx, r, p) => _buildVehiclesTab(ctx, p)),
                      ),
                    if (currentMember?.hasPermission('health.medical_data') ?? false)
                      _buildPremiumMenuTile(
                        context,
                        icon: Icons.monitor_heart_rounded,
                        title: 'Información de Salud',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MainLayout(
                          activeIndex: 2,
                          child: HealthView(),
                        ))),
                      ),
                    if (currentMember?.hasPermission('financial.view') ?? false)
                      _buildPremiumMenuTile(
                        context,
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Saldos y Finanzas',
                        onTap: () => _navigateToSection(context, 'Finanzas', 'Consulta de saldos y cargos', Icons.account_balance_wallet_outlined, (ctx, r, p) => _buildFinancesTab(ctx, r, p)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildPremiumMenuTile(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Cerrar Sesión Completa',
                  isDestructive: true,
                  isHorizontal: true,
                  onTap: () => _showLogoutConfirmation(context, ref),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            '¿Estás seguro de que deseas cerrar tu sesión completamente?\n\n'
            'Esto removerá tu cuenta del dispositivo y deberás iniciar sesión nuevamente '
            '(no podrás usar biometría hasta que vuelvas a configurar el acceso con código).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.neutral500)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _performFullLogout(ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dangerColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  void _performFullLogout(WidgetRef ref) {
    ref.read(authProvider.notifier).logout();
    ref.read(apiClientNotifierProvider.notifier).updateToken('');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  void _navigateToSection(BuildContext context, String title, String subtitle, IconData icon, Widget Function(BuildContext, WidgetRef, ProfileModel) builder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            final profileAsync = ref.watch(profileProvider);
            return profileAsync.when(
              data: (profile) {
                if (profile == null) return const Scaffold(body: Center(child: Text('Perfil no encontrado')));
                return MainLayout(
                  activeIndex: 2,
                  child: Scaffold(
                    appBar: CustomPremiumAppBar(
                      title: title,
                      subtitle: subtitle,
                      icon: icon,
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: SafeArea(
                      bottom: false,
                      child: builder(context, ref, profile),
                    ),
                  ),
                );
              },
              loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))),
              error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPremiumMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool isHorizontal = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDestructive ? AppTheme.dangerColor : AppTheme.primaryColor;
    
    return Container(
      decoration: BoxDecoration(
        color: isDestructive ? color.withOpacity(0.05) : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDestructive ? color.withOpacity(0.3) : AppTheme.neutral200.withOpacity(isDark ? 0.1 : 0.4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: isHorizontal
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 15,
                            color: isDestructive ? color : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title, 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 13, 
                          height: 1.2,
                          color: isDestructive ? color : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHero(BuildContext context, ProfileModel profile) {
    final String cleanName = profile.fullname.replaceFirst(RegExp(r'^\d+\s*'), '');

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        border: Border.all(color: AppTheme.neutral200.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage: profile.profilePicture != null 
                  ? MemoryImage(base64Decode(profile.profilePicture!.split(',').last)) 
                  : null,
                child: profile.profilePicture == null 
                  ? Text(
                      profile.firstName?.isNotEmpty == true ? profile.firstName!.substring(0, 1).toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _onEditPhoto,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    cleanName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Socio: ${profile.entityid}',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 8),
          _buildSmallQr(context, profile),
        ],
      ),
    );
  }

  Widget _buildSmallQr(BuildContext context, ProfileModel profile) {
    final qrData = 'MEMBER:${profile.entityid}:${profile.id}';
    final String cleanName = profile.fullname.replaceFirst(RegExp(r'^\d+\s*'), '');

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'qr-code-hero',
                  flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                    return DefaultTextStyle(
                      style: DefaultTextStyle.of(toHeroContext).style,
                      child: toHeroContext.widget,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 250.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.circle,
                              color: Colors.black,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'CARNET DIGITAL',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppTheme.neutral500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cleanName.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Utiliza este código para identificarte en temas relacionados con tu membresía.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.neutral500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  right: -20,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Hero(
        tag: 'qr-code-hero',
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 56.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTab(BuildContext context, WidgetRef ref, ProfileModel profile) {
    final bool canEdit = profile.canEditSensitiveData;
    final currentMember = ref.watch(authProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cambio de Datos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.white70 
                                : AppTheme.neutral700,
                            height: 1.5,
                          ),
                          children: const [
                            TextSpan(text: 'Si detectas que alguno de los datos que se muestran es incorrecto o necesitas actualizarlo '),
                            TextSpan(text: '(sobre todo para los datos de dirección personales y datos fiscales)', style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(text: ', por favor contáctanos:\n\n'),
                            TextSpan(text: '• Hermes: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(text: '55 5228 9933 ext. 2900\n'),
                            TextSpan(text: '• Glaciar: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(text: '55 5668 6068 ext. 6107\n'),
                            TextSpan(text: '• Correo: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(text: 'cobranza@centrolibanes.org.mx\n\n'),
                            TextSpan(text: '¡Nos dará mucho gusto apoyarte!', style: TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.mark_email_read_outlined, size: 18),
                        label: const Text('Solicitar Actualización de Datos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _showUpdateDataModal(context, profile),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Datos Personales', Icons.person_outline_rounded),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                _buildInfoRow(context, 'Correo electrónico', profile.email ?? 'No registrado', Icons.alternate_email_rounded),
                const Divider(height: 32),
                _buildInfoRow(context, 'Teléfono', profile.phone ?? 'No registrado', Icons.phone_android_rounded),
              ],
            ),
          ),
          if (profile.associatedMembers.isNotEmpty) ...[
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Miembros Asociados', Icons.people_outline_rounded),
            const SizedBox(height: 16),
            ...profile.associatedMembers.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: (currentMember?.isTitular ?? false)
                      ? _buildFamilyMemberPermissions(context, ref, member)
                      : _buildAssociatedCard(context, member),
                )),
          ],
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Dirección Personal', Icons.location_on_outlined),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                _buildSensitiveField(
                  context, 
                  'C.P.', 
                  canEdit, 
                  controller: _cpCtrl, 
                  icon: Icons.markunread_mailbox_outlined,
                  helperText: 'Ingresa tu C.P. para autocompletar tu dirección',
                  suffixIcon: _isSearchingCp 
                      ? const Padding(
                          padding: EdgeInsets.all(12), 
                          child: SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor)
                          )
                        ) 
                      : null,
                ),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Estado', canEdit, controller: _estadoCtrl, icon: Icons.map_rounded, helperText: 'Autocompletado al ingresar el C.P.'),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Ciudad o Municipio', canEdit, controller: _ciudadCtrl, icon: Icons.location_city_outlined, helperText: 'Autocompletado al ingresar el C.P.'),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Colonia', canEdit, controller: _coloniaCtrl, icon: Icons.holiday_village_outlined, helperText: 'Autocompletado al ingresar el C.P.'),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Calle', canEdit, controller: _streetCtrl, icon: Icons.map_outlined),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildSensitiveField(context, 'No. Exterior', canEdit, controller: _extNumCtrl, icon: Icons.numbers_rounded)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSensitiveField(context, 'No. Interior', canEdit, controller: _intNumCtrl)),
                  ],
                ),
                if (canEdit) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveAddress(profile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Guardar Dirección', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Datos Fiscales', Icons.receipt_long_outlined),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                _buildSensitiveField(context, 'RFC', canEdit, controller: _rfcCtrl, icon: Icons.badge_outlined),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Razón Social', canEdit, controller: _razonSocialCtrl, icon: Icons.business_rounded),
                const SizedBox(height: 16),
                _buildSensitiveField(
                  context, 
                  'Régimen Fiscal', 
                  canEdit, 
                  controller: _regimenCtrl, 
                  icon: Icons.account_balance_outlined,
                  onTap: () {
                    final catalogs = ref.read(satCatalogsProvider).value;
                    if (catalogs != null) {
                      final options = catalogs.regimenesFiscales.map((e) => e.displayString).toList();
                      _showGenericSelector('Selecciona tu Régimen Fiscal', options, _regimenCtrl, Icons.account_balance_rounded);
                    } else {
                      ToastAlerts.showWarning(context, 'Cargando catálogos del SAT...');
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildSensitiveField(
                  context, 
                  'Uso CFDI', 
                  canEdit, 
                  controller: _usoCfdiCtrl, 
                  icon: Icons.receipt_long_outlined,
                  onTap: () {
                    final catalogs = ref.read(satCatalogsProvider).value;
                    if (catalogs != null) {
                      final options = catalogs.usosCfdi.map((e) => e.displayString).toList();
                      _showGenericSelector('Selecciona el Uso de CFDI', options, _usoCfdiCtrl, Icons.receipt_long_rounded);
                    } else {
                      ToastAlerts.showWarning(context, 'Cargando catálogos del SAT...');
                    }
                  },
                ),
                const SizedBox(height: 24),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppTheme.neutral200.withOpacity(0.5)),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppTheme.primaryColor),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                    iconColor: AppTheme.primaryColor,
                    textColor: AppTheme.primaryColor,
                    title: const Text(
                      'Usar dirección fiscal diferente',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    initiallyExpanded: !_isSameAddress,
                    onExpansionChanged: canEdit 
                        ? (expanded) {
                            setState(() => _isSameAddress = !expanded);
                          }
                        : null,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildSensitiveField(
                              context, 
                              'C.P. Fiscal', 
                              canEdit, 
                              controller: _fiscalCpCtrl, 
                              icon: Icons.markunread_mailbox_outlined,
                              helperText: 'Ingresa tu C.P. para autocompletar',
                            ),
                            const SizedBox(height: 16),
                            _buildSensitiveField(context, 'Estado Fiscal', canEdit, controller: _fiscalEstadoCtrl, icon: Icons.map_rounded),
                            const SizedBox(height: 16),
                            _buildSensitiveField(context, 'Ciudad / Mpio. Fiscal', canEdit, controller: _fiscalCiudadCtrl, icon: Icons.location_city_outlined),
                            const SizedBox(height: 16),
                            _buildSensitiveField(context, 'Colonia Fiscal', canEdit, controller: _fiscalColoniaCtrl, icon: Icons.holiday_village_outlined),
                            const SizedBox(height: 16),
                            _buildSensitiveField(context, 'Calle Fiscal', canEdit, controller: _fiscalStreetCtrl, icon: Icons.map_outlined),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildSensitiveField(context, 'No. Exterior', canEdit, controller: _fiscalExtNumCtrl, icon: Icons.numbers_rounded)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildSensitiveField(context, 'No. Interior', canEdit, controller: _fiscalIntNumCtrl)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (canEdit) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveFiscalData(profile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Guardar Datos Fiscales', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 120), // Padding for island menu
        ],
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context, WidgetRef ref, ProfileModel profile) {
    final settings = profile.settings;
    final themeMode = ref.watch(themeProvider);
    final currentMember = ref.watch(authProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Preferencias de la App', Icons.tune_rounded),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                _buildThemeSelector(
                  context,
                  currentMode: themeMode,
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(themeProvider.notifier).setThemeMode(val);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Notificaciones', Icons.notifications_none_rounded),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                _buildConfigSwitch(
                  context,
                  title: 'Correo Electrónico',
                  subtitle: 'Avisos de eventos y estados de cuenta',
                  icon: Icons.email_outlined,
                  value: settings.emailNotifications,
                  onChanged: (val) {
                    ref.read(profileProvider.notifier).updateSettings(settings.copyWith(emailNotifications: val));
                  },
                ),
                const Divider(height: 32),
                _buildConfigSwitch(
                  context,
                  title: 'Notificaciones Push',
                  subtitle: 'Alertas en tiempo real',
                  icon: Icons.notifications_active_outlined,
                  value: settings.pushNotifications,
                  onChanged: (val) {
                    ref.read(profileProvider.notifier).updateSettings(settings.copyWith(pushNotifications: val));
                  },
                ),
                const Divider(height: 32),
                _buildConfigSwitch(
                  context,
                  title: 'Recordatorios de Clases',
                  subtitle: 'Avisos antes de iniciar tus actividades',
                  icon: Icons.calendar_today_rounded,
                  value: settings.classReminders,
                  onChanged: (val) {
                    ref.read(profileProvider.notifier).updateSettings(settings.copyWith(classReminders: val));
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text(
                  'ArzSuite v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral400),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Términos y Condiciones'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120), // Padding for island menu
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, {bool requiresApproval = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isDark ? Colors.white70 : AppTheme.neutral700,
              ),
        ),
        if (requiresApproval) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
            ),
            child: const Text(
              'Requiere aprobación',
              style: TextStyle(color: AppTheme.warningColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSensitiveField(
    BuildContext context, 
    String label, 
    bool canEdit, 
    {
      required TextEditingController controller, 
      IconData? icon, 
      Widget? suffixIcon, 
      String? helperText,
      VoidCallback? onTap,
    }
  ) {
    return TextFormField(
      controller: controller,
      readOnly: !canEdit || onTap != null,
      onTap: canEdit ? onTap : null,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: canEdit ? null : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperStyle: helperText != null && helperText.contains('Autocompletado') 
            ? const TextStyle(color: AppTheme.primaryColor, fontStyle: FontStyle.italic) 
            : null,
        prefixIcon: icon != null 
            ? Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))
            : null,
        suffixIcon: suffixIcon ?? (onTap != null && canEdit ? const Icon(Icons.arrow_drop_down_rounded) : null),
      ),
    );
  }

  Widget _buildFamilyMemberPermissions(BuildContext context, WidgetRef ref, SubMemberModel member) {
    final String cleanName = member.fullname.replaceFirst(RegExp(r'^\d+\s*'), '');
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(cleanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('${member.memberType} • ID: ${member.membershipNumber}', style: const TextStyle(fontSize: 12, color: AppTheme.neutral500)),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildConfigSwitch(
                  context,
                  title: 'Saldos y Finanzas',
                  subtitle: 'Consultar saldos y pagos',
                  icon: Icons.account_balance_wallet_outlined,
                  value: member.permissions.contains('financial.view'),
                  onChanged: (val) async {
                    try {
                      await ref.read(profileProvider.notifier).updateFamilyMemberPermission(member.id, 'financial.view', val);
                    } catch (e) {
                      if (context.mounted) ToastAlerts.showError(context, 'Error al actualizar permiso');
                    }
                  },
                ),
                const Divider(height: 24),
                _buildConfigSwitch(
                  context,
                  title: 'Información de Salud',
                  subtitle: 'Acceso a expediente médico',
                  icon: Icons.monitor_heart_outlined,
                  value: member.permissions.contains('health.medical_data'),
                  onChanged: (val) async {
                    try {
                      await ref.read(profileProvider.notifier).updateFamilyMemberPermission(member.id, 'health.medical_data', val);
                    } catch (e) {
                      if (context.mounted) ToastAlerts.showError(context, 'Error al actualizar permiso');
                    }
                  },
                ),
                const Divider(height: 24),
                _buildConfigSwitch(
                  context,
                  title: 'Mis Vehículos',
                  subtitle: 'Registro de automóvil',
                  icon: Icons.directions_car_outlined,
                  value: member.permissions.contains('profile.vehicles'),
                  onChanged: (val) async {
                    try {
                      await ref.read(profileProvider.notifier).updateFamilyMemberPermission(member.id, 'profile.vehicles', val);
                    } catch (e) {
                      if (context.mounted) ToastAlerts.showError(context, 'Error al actualizar permiso');
                    }
                  },
                ),
                const Divider(height: 24),
                _buildConfigSwitch(
                  context,
                  title: 'Inscripción a Actividades',
                  subtitle: 'Inscripción a actividades deportivas y culturales',
                  icon: Icons.sports_tennis_rounded,
                  value: member.permissions.contains('activities.enroll'),
                  onChanged: (val) async {
                    try {
                      await ref.read(profileProvider.notifier).updateFamilyMemberPermission(member.id, 'activities.enroll', val);
                    } catch (e) {
                      if (context.mounted) ToastAlerts.showError(context, 'Error al actualizar permiso');
                    }
                  },
                ),
                const Divider(height: 24),
                _buildConfigSwitch(
                  context,
                  title: 'Curso de Verano',
                  subtitle: 'Inscripción al curso de verano',
                  icon: Icons.wb_sunny_outlined,
                  value: member.permissions.contains('summer_course.enroll'),
                  onChanged: (val) async {
                    try {
                      await ref.read(profileProvider.notifier).updateFamilyMemberPermission(member.id, 'summer_course.enroll', val);
                    } catch (e) {
                      if (context.mounted) ToastAlerts.showError(context, 'Error al actualizar permiso');
                    }
                  },
                ),
                const Divider(height: 24),
                _buildConfigSwitch(
                  context,
                  title: 'Administrador Familiar',
                  subtitle: 'Gestionar a otros familiares',
                  icon: Icons.family_restroom_rounded,
                  value: member.permissions.contains('manage_family'),
                  onChanged: (val) async {
                    try {
                      await ref.read(profileProvider.notifier).updateFamilyMemberPermission(member.id, 'manage_family', val);
                    } catch (e) {
                      if (context.mounted) ToastAlerts.showError(context, 'Error al actualizar permiso');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssociatedCard(BuildContext context, SubMemberModel member) {
    final String cleanName = member.fullname.replaceFirst(RegExp(r'^\d+\s*'), '');
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          border: Border.all(color: AppTheme.neutral200.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.neutral100,
              radius: 20,
              child: const Icon(Icons.person_rounded, color: AppTheme.neutral500, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleanName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${member.memberType} • ID: ${member.membershipNumber}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildCard(BuildContext context, {required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(AppTheme.spacingMedium)}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        border: Border.all(color: AppTheme.neutral200.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.neutral500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigSwitch(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.neutral500, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context, {
    required ThemeMode currentMode,
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              currentMode == ThemeMode.dark ? Icons.dark_mode_outlined : 
              currentMode == ThemeMode.light ? Icons.light_mode_outlined : 
              Icons.brightness_auto_outlined, 
              color: AppTheme.neutral500, size: 22
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tema de la Aplicación', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Selecciona la apariencia', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.neutral100.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.1 : 1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _buildThemeOption(
                context,
                title: 'Claro',
                icon: Icons.light_mode_outlined,
                mode: ThemeMode.light,
                currentMode: currentMode,
                onTap: () => onChanged(ThemeMode.light),
              ),
              _buildThemeOption(
                context,
                title: 'Oscuro',
                icon: Icons.dark_mode_outlined,
                mode: ThemeMode.dark,
                currentMode: currentMode,
                onTap: () => onChanged(ThemeMode.dark),
              ),
              _buildThemeOption(
                context,
                title: 'Auto',
                icon: Icons.phone_iphone_rounded,
                mode: ThemeMode.system,
                currentMode: currentMode,
                onTap: () => onChanged(ThemeMode.system),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
  }) {
    final isSelected = mode == currentMode;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected 
                    ? Colors.white 
                    : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppTheme.neutral600),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected 
                      ? Colors.white 
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppTheme.neutral600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildBeneficiariesTab(BuildContext context, ProfileModel profile) {
    final beneficiaries = profile.legalBeneficiaries;
    final family = profile.associatedMembers.where((m) => m.id != profile.id).toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Beneficiarios Legales', Icons.family_restroom_rounded),
          const SizedBox(height: 16),
          const Text('Próximamente podrás registrar tus beneficiarios legales a través de esta aplicación.'),
          const SizedBox(height: 16),
          /*
          _buildCard(
            context,
            child: Column(
              children: [
                if (beneficiaries.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No has asignado ningún beneficiario legal.'),
                  )
                ] else ...[
                  for (var i = 0; i < beneficiaries.length; i++) ...[
                    if (i > 0) const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.person, color: AppTheme.primaryColor),
                      title: Text(
                        family.firstWhere(
                          (m) => m.id == beneficiaries[i]['beneficiary_socio_id'].toString(),
                          orElse: () => SubMemberModel(id: '', fullname: 'Miembro desconocido', membershipNumber: '', memberType: ''),
                        ).fullname,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.dangerColor),
                        onPressed: () => _removeBeneficiary(beneficiaries[i]['id']),
                      ),
                    ),
                  ],
                ],
                if (beneficiaries.length < 3) ...[
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Asignar Beneficiario'),
                        onPressed: family.isEmpty ? null : () => _showAddBeneficiaryDialog(context, family, beneficiaries),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          */
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  void _showUpdateDataModal(BuildContext context, ProfileModel profile) {
    String selectedRequest = 'Cambio de dirección';
    final detailsController = TextEditingController();
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24, right: 24, top: 24,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Actualización de Datos',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Selecciona el tipo de actualización que necesitas:'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedRequest,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Cambio de dirección', child: Text('Cambio de dirección')),
                      DropdownMenuItem(value: 'Actualización de RFC / Datos Fiscales', child: Text('Actualización de RFC / Datos Fiscales')),
                      DropdownMenuItem(value: 'Cambio de correo electrónico', child: Text('Cambio de correo electrónico')),
                      DropdownMenuItem(value: 'Cambio de número de teléfono', child: Text('Cambio de número de teléfono')),
                      DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedRequest = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: detailsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Detalles de la solicitud',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'Describe brevemente qué datos necesitas cambiar...',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSending ? null : () async {
                        if (detailsController.text.trim().isEmpty) {
                          ToastAlerts.showWarning(context, 'Por favor ingresa los detalles de tu solicitud.');
                          return;
                        }
                        
                        setModalState(() => isSending = true);
                        
                        final success = await ResendService.sendUpdateRequest(
                          memberName: profile.fullname,
                          memberPhone: profile.phone ?? 'No registrado',
                          membershipNumber: profile.membershipNumber,
                          requestType: selectedRequest,
                          details: detailsController.text.trim(),
                          memberEmail: profile.email ?? 'No registrado',
                        );
                        
                        setModalState(() => isSending = false);
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (success) {
                            ToastAlerts.showSuccess(context, 'Solicitud enviada correctamente. Nos comunicaremos contigo pronto.');
                          } else {
                            ToastAlerts.showError(context, 'Ocurrió un error al enviar la solicitud. Intenta más tarde.');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isSending 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Enviar Solicitud', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showAddBeneficiaryDialog(BuildContext context, List<SubMemberModel> family, List<dynamic> currentBeneficiaries) {
    final availableFamily = family.where((f) {
      return !currentBeneficiaries.any((b) => b['beneficiary_socio_id'].toString() == f.id);
    }).toList();

    if (availableFamily.isEmpty) {
      ToastAlerts.showWarning(context, 'No hay más miembros de familia disponibles para asignar.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Asignar Beneficiario'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableFamily.length,
              itemBuilder: (context, index) {
                final member = availableFamily[index];
                return ListTile(
                  title: Text(member.fullname),
                  subtitle: Text(member.memberType),
                  onTap: () {
                    Navigator.pop(context);
                    _addBeneficiary(member.id);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addBeneficiary(String id) async {
    try {
      await ref.read(profileProvider.notifier).addBeneficiary(id);
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Beneficiario asignado');
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, 'Error: $e');
      }
    }
  }

  Future<void> _removeBeneficiary(dynamic id) async {
    try {
      await ref.read(profileProvider.notifier).removeBeneficiary(int.parse(id.toString()));
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Beneficiario removido');
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, 'Error: $e');
      }
    }
  }

  Widget _buildVehiclesTab(BuildContext context, ProfileModel profile) {
    final bool isSpecial = [1, 2, 3, 6, 10].contains(profile.patrimonialConditionId);
    final vehicles = profile.vehicles;

    if (isSpecial) {
      final access1Vehicles = vehicles.where((v) => v['access_number'] == 1).toList();
      final access2Vehicles = vehicles.where((v) => v['access_number'] == 2).toList();
      
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          _buildSectionHeader(context, 'Placas Autorizadas', Icons.directions_car_rounded),
          const SizedBox(height: 16),
          const Text('Registro informativo: Incluye 2 accesos de hasta 5 autos cada uno.\nImportante: Solo 1 auto por acceso puede ingresar al mismo tiempo.'),
          const SizedBox(height: 16),
            _buildAccessSection(context, 'Placas registradas (Acceso 1)', access1Vehicles, 1),
            const SizedBox(height: 24),
            _buildAccessSection(context, 'Placas registradas (Acceso 2)', access2Vehicles, 2),
            const SizedBox(height: 32),
            _buildParkingDisclaimer(),
            const SizedBox(height: 120),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Placas Autorizadas', Icons.directions_car_rounded),
          const SizedBox(height: 16),
          const Text('Vehículos registrados para acceso al estacionamiento (máximo 5). Solo 1 puede estar en el estacionamiento a la vez.'),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                if (vehicles.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No has registrado ningún vehículo.'),
                  )
                ] else ...[
                  for (var i = 0; i < vehicles.length; i++) ...[
                    if (i > 0) const Divider(height: 0),
                    _buildVehicleTile(context, vehicles[i]),
                  ],
                ],
                if (vehicles.length < 5) ...[
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Registrar Vehículo'),
                        onPressed: () => _showVehicleDialog(context, null),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildAccessSection(BuildContext context, String title, List<dynamic> accessVehicles, int accessNumber) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  '${accessVehicles.length} / 5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: accessVehicles.length >= 5 ? AppTheme.dangerColor : AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          if (accessVehicles.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No hay vehículos en este acceso.'),
            )
          ] else ...[
            for (var i = 0; i < accessVehicles.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              _buildVehicleTile(context, accessVehicles[i]),
            ],
          ],
          if (accessVehicles.length < 5) ...[
            const Divider(height: 0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Vehículo'),
                  onPressed: () => _showVehicleDialog(context, null, accessNumber: accessNumber),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Nota: Solo podrá estar dentro del estacionamiento 1 auto de este grupo a la vez.',
                style: TextStyle(fontSize: 12, color: AppTheme.neutral500),
                textAlign: TextAlign.center,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildVehicleTile(BuildContext context, dynamic vehicle) {
    return ListTile(
      leading: Icon(Icons.directions_car, color: vehicle['is_in_parking'] == true ? AppTheme.successColor : AppTheme.primaryColor),
      title: Text('Placas: ${vehicle['plates'] ?? ''}'),
      subtitle: Text('${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}'.trim()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (vehicle['is_in_parking'] == true)
            const Tooltip(message: 'En estacionamiento', child: Icon(Icons.local_parking, color: AppTheme.successColor)),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showVehicleDialog(context, vehicle, accessNumber: vehicle['access_number'] ?? 1),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.dangerColor),
            onPressed: () => _disableVehicle(vehicle['id']),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : AppTheme.neutral100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutral300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Al registrar tus vehículos declaras aceptar el reglamento y condiciones.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Causas principales de pérdida de accesos:\n'
            '• Mal uso, alteración o falsificación del registro de placas.\n'
            '• Permitir el ingreso simultáneo de 2 o más autos usando el mismo acceso.\n'
            '• Incumplimiento general de las disposiciones de estacionamiento.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final Uri url = Uri.parse('https://registro-vehicular.centrolibanes.org.mx/files/REGLAMENTO_ESTACIONAMIENTO.pdf');
              if (!await launchUrl(url)) {
                if (mounted) ToastAlerts.showError(context, 'No se pudo abrir el enlace');
              }
            },
            child: const Text(
              'Consulta el reglamento completo AQUÍ.',
              style: TextStyle(fontSize: 12, color: AppTheme.primaryColor, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  void _showVehicleDialog(BuildContext context, Map<String, dynamic>? vehicle, {int accessNumber = 1}) {
    final isEditing = vehicle != null;
    final platesCtrl = TextEditingController(text: vehicle?['plates']?.toString() ?? '');
    final makeCtrl = TextEditingController(text: vehicle?['make']?.toString() ?? '');
    final modelCtrl = TextEditingController(text: vehicle?['model']?.toString() ?? '');
    final colorCtrl = TextEditingController(text: vehicle?['color']?.toString() ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
            return Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Editar Vehículo' : 'Registrar Vehículo',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(controller: platesCtrl, decoration: const InputDecoration(labelText: 'Placas *', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    TextField(controller: makeCtrl, decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    TextField(controller: modelCtrl, decoration: const InputDecoration(labelText: 'Modelo', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    TextField(controller: colorCtrl, decoration: const InputDecoration(labelText: 'Color', border: OutlineInputBorder())),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final plates = platesCtrl.text.trim();
                              if (plates.isEmpty) {
                                ToastAlerts.showWarning(context, 'Las placas son obligatorias');
                                return;
                              }
                              final data = {
                                'plates': plates,
                                'make': makeCtrl.text.trim(),
                                'model': modelCtrl.text.trim(),
                                'color': colorCtrl.text.trim(),
                                'access_number': isEditing ? (vehicle['access_number'] ?? accessNumber) : accessNumber,
                              };
                              Navigator.pop(context);
                              if (isEditing) {
                                _editVehicle(vehicle['id'], data);
                              } else {
                                _addVehicle(data);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Future<void> _addVehicle(Map<String, dynamic> data) async {
    try {
      await ref.read(profileProvider.notifier).addVehicle(data);
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Vehículo registrado');
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, 'Error: $e');
      }
    }
  }

  Future<void> _editVehicle(dynamic id, Map<String, dynamic> data) async {
    try {
      await ref.read(profileProvider.notifier).editVehicle(int.parse(id.toString()), data);
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Vehículo actualizado');
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, 'Error: $e');
      }
    }
  }

  Future<void> _disableVehicle(dynamic id) async {
    try {
      await ref.read(profileProvider.notifier).disableVehicle(int.parse(id.toString()));
      if (mounted) {
        ToastAlerts.showSuccess(context, 'Vehículo removido');
      }
    } catch (e) {
      if (mounted) {
        ToastAlerts.showError(context, 'Error: $e');
      }
    }
  }

  Widget _buildFinancesTab(BuildContext context, WidgetRef ref, ProfileModel profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paymentsAsync = ref.watch(userPaymentsProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: paymentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          final pendingBalance = data['pending_balance'] ?? 0;
          final nextCharge = data['next_charge_amount'] ?? 0;
          final dueMonths = data['due_months'] ?? 0;
          final paymentFrequency = data['payment_frequency'] as String?;
          final membershipStatus = data['membership_status'] as String? ?? 'Activa';
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen Financiero',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              Text(
                'Saldo actual, transacciones y estado de cuenta',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              
              Column(
                children: [
                  _buildFinanceCard(
                    context, 
                    icon: Icons.account_balance_wallet_rounded, 
                    title: 'Saldo Vencido', 
                    value: NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(pendingBalance),
                    isPrimary: pendingBalance > 0,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFinanceCard(
                    context, 
                    icon: Icons.credit_card_rounded, 
                    title: 'Frecuencia de Pago', 
                    value: paymentFrequency ?? 'No registrada',
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFinanceCard(
                    context, 
                    icon: Icons.verified_user_rounded, 
                    title: 'Estatus de la Membresía', 
                    value: membershipStatus,
                    isStatus: true,
                    fullWidth: true,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Text(
                'Historial y Cargos Recientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 16),

              if ((data['history'] as List).isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Sin movimientos', style: TextStyle(color: AppTheme.neutral500.withOpacity(0.8))),
                  ),
                )
              else
                ...((data['history'] as List).map((h) {
                    final isPending = h['status'] == 'pending';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.neutral900 : AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isPending 
                            ? AppTheme.warningColor.withOpacity(isDark ? 0.3 : 0.6)
                            : (isDark ? AppTheme.neutral800 : AppTheme.neutral200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isPending 
                                ? AppTheme.warningColor.withOpacity(0.1)
                                : AppTheme.successColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPending ? Icons.access_time_filled_rounded : Icons.check_circle_rounded,
                              color: isPending ? AppTheme.warningColor : AppTheme.successColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  h['sales_order_id'] ?? 'Movimiento',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (h['module'] ?? '').toString().replaceAll('_', ' ').toUpperCase(),
                                  style: TextStyle(fontSize: 11, color: AppTheme.neutral500.withOpacity(0.8), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(h['amount'] ?? 0),
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                })),
              const SizedBox(height: 120),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFinanceCard(
    BuildContext context, {
    required IconData icon, 
    required String title, 
    required String value, 
    bool isStatus = false,
    bool isPrimary = false,
    bool fullWidth = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.neutral200.withOpacity(isDark ? 0.1 : 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPrimary ? AppTheme.vibrantGold.withOpacity(0.15) : AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isPrimary ? AppTheme.vibrantGold : AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: value.toLowerCase() == 'ausente' ? AppTheme.warningColor : AppTheme.successColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            )
          else
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isPrimary ? AppTheme.vibrantGold : Theme.of(context).colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}
