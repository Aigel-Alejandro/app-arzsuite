import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/api_client_notifier.dart';
import '../../../core/widgets/main_layout.dart';
import '../../auth/views/login_view.dart';
import '../providers/profile_provider.dart';
import '../models/profile_model.dart';
import '../models/sub_member_model.dart';

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

  @override
  void initState() {
    super.initState();
    _cpCtrl.addListener(_onCpChanged);
  }

  void _onCpChanged() {
    final cp = _cpCtrl.text.trim();
    if (cp.length == 5 && int.tryParse(cp) != null && cp != _lastSearchedCp) {
      _fetchAddressByCp(cp);
    }
  }

  Future<void> _fetchAddressByCp(String cp) async {
    if (!mounted) return;
    setState(() => _isSearchingCp = true);
    _lastSearchedCp = cp;

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
            if (estado.isNotEmpty) _estadoCtrl.text = estado;
            // Fallback for CDMX where locality is scarce
            _ciudadCtrl.text = ciudad.isNotEmpty ? ciudad : estado;
          });

          // Google sometimes provides an array of localities inside the postal code area
          final localities = result['postcode_localities'] as List<dynamic>?;
          
          if (localities != null && localities.isNotEmpty) {
            final colonias = localities.map((e) => e.toString()).toList();
            if (colonias.length == 1) {
               setState(() => _coloniaCtrl.text = colonias[0]);
            } else {
               _showColoniaSelector(colonias);
            }
          } else if (coloniaSola.isNotEmpty) {
            setState(() => _coloniaCtrl.text = coloniaSola);
          }
        } else {
          throw Exception('No result geometry found');
        }
      }
    } catch (e) {
      debugPrint('Error fetching CP with Google Maps: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró información extra para este código postal.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSearchingCp = false);
      }
    }
  }

  void _showColoniaSelector(List<String> colonias) {
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
                          _coloniaCtrl.text = colonia;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subiendo foto de perfil...')),
      );

      await ref.read(profileProvider.notifier).updateProfile(
        profilePictureBase64: dataUri,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil actualizada')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la foto: $e'), backgroundColor: AppTheme.dangerColor),
      );
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
    _cpCtrl.text = personalAddress['zip_code'] ?? '';
    _lastSearchedCp = _cpCtrl.text;

    final fiscalData = profile.fiscalData ?? {};
    _rfcCtrl.text = fiscalData['rfc'] ?? profile.rfc ?? '';
    _razonSocialCtrl.text = fiscalData['business_name'] ?? '';
    _regimenCtrl.text = fiscalData['tax_regime'] ?? '';
    _usoCfdiCtrl.text = fiscalData['cfdi_use'] ?? '';

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dirección actualizada (pendiente de aprobación)')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.dangerColor));
    }
  }

  Future<void> _saveFiscalData(ProfileModel profile) async {
    final updatedFiscal = Map<String, dynamic>.from(profile.fiscalData ?? {});
    updatedFiscal['rfc'] = _rfcCtrl.text.trim();
    updatedFiscal['business_name'] = _razonSocialCtrl.text.trim();
    updatedFiscal['tax_regime'] = _regimenCtrl.text.trim();
    updatedFiscal['cfdi_use'] = _usoCfdiCtrl.text.trim();
    
    try {
      await ref.read(profileProvider.notifier).updateProfile(fiscalData: updatedFiscal);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos fiscales actualizados (pendiente de aprobación)')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.dangerColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return MainLayout(
      activeIndex: 2,
      child: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Perfil no encontrado'));
          }
          
          if (!_isInit) _initControllers(profile);

          return DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, 32, AppTheme.spacingLarge, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              IconButton(
                                icon: const Icon(Icons.logout_rounded, color: AppTheme.dangerColor),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Cerrar Sesión'),
                                      content: const Text('¿Estás seguro de que deseas salir de tu cuenta?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _onLogout();
                                          },
                                          style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
                                          child: const Text('Salir'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                tooltip: 'Cerrar sesión',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildProfileHero(context, profile),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: AppTheme.primaryColor,
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: AppTheme.neutral500,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 24),
                        indicatorPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: -12),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppTheme.primaryColor.withOpacity(0.1),
                        ),
                        tabs: const [
                          Tab(text: 'Acceso'),
                          Tab(text: 'Cuenta'),
                          Tab(text: 'Ajustes'),
                        ],
                      ),
                      Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildAccessTab(context, profile),
                  _buildAccountTab(context, profile),
                  _buildSettingsTab(context, ref, profile),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (error, _) => Center(child: Text('Error: $error')),
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
        ],
      ),
    );
  }

  Widget _buildAccessTab(BuildContext context, ProfileModel profile) {
    final qrData = 'MEMBER:${profile.entityid}:${profile.id}';
    final String cleanName = profile.fullname.replaceFirst(RegExp(r'^\d+\s*'), '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        children: [
          _buildCard(
            context,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 220.0,
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
                const SizedBox(height: 32),
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
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Utiliza este código para acceder a las instalaciones del club. Llévalo siempre contigo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.neutral500,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120), // Padding for island menu
        ],
      ),
    );
  }

  Widget _buildAccountTab(BuildContext context, ProfileModel profile) {
    final bool canEdit = profile.canEditSensitiveData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Dirección Personal', Icons.location_on_outlined, requiresApproval: true),
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
          _buildSectionHeader(context, 'Datos Fiscales', Icons.receipt_long_outlined, requiresApproval: true),
          const SizedBox(height: 16),
          _buildCard(
            context,
            child: Column(
              children: [
                _buildSensitiveField(context, 'RFC', canEdit, controller: _rfcCtrl, icon: Icons.badge_outlined),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Razón Social', canEdit, controller: _razonSocialCtrl, icon: Icons.business_rounded),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Régimen Fiscal', canEdit, controller: _regimenCtrl, icon: Icons.account_balance_outlined),
                const SizedBox(height: 16),
                _buildSensitiveField(context, 'Uso CFDI', canEdit, controller: _usoCfdiCtrl, icon: Icons.receipt_long_outlined),
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
          if (profile.associatedMembers.isNotEmpty) ...[
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Miembros Asociados', Icons.people_outline_rounded),
            const SizedBox(height: 16),
            ...profile.associatedMembers.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildAssociatedCard(context, member),
                )),
          ],
          const SizedBox(height: 120), // Padding for island menu
        ],
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context, WidgetRef ref, ProfileModel profile) {
    final settings = profile.settings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
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
                _buildConfigSwitch(
                  context,
                  title: 'Modo Oscuro',
                  subtitle: 'Cambiar apariencia de la interfaz',
                  icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeProvider.notifier).setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
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

  Widget _buildSensitiveField(BuildContext context, String label, bool canEdit, {required TextEditingController controller, IconData? icon, Widget? suffixIcon, String? helperText}) {
    return TextFormField(
      controller: controller,
      readOnly: !canEdit,
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
        suffixIcon: suffixIcon,
      ),
    );
  }


  Widget _buildAssociatedCard(BuildContext context, SubMemberModel member) {
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
                  member.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${member.memberType} • ID: ${member.membershipNumber}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppTheme.neutral300),
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.backgroundColor);

  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height + 16;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 16;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.neutral100.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 1),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(4),
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
