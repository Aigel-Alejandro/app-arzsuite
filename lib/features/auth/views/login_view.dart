import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/core/network/api_endpoints.dart';
import 'package:app_arzsuite/core/providers/global_providers.dart';
import '../../home/views/home_view.dart';
import '../../../core/providers/auth_provider.dart';
import '../../summer_course/models/member.dart';
import 'package:app_arzsuite/core/auth/biometric_auth.dart';
import '../../../core/providers/api_client_notifier.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pantalla de login moderna con flujo de dos pasos para Socios.
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // TOGGLE TEMPORAL: Cambiar a false para regresar al OTP de WhatsApp
  static const bool _useTempPasswordLogin = true;

  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _codeSent = false;
  final BiometricAuth _localAuth = BiometricAuth();
  bool _hasBiometricsSaved = false;
  String _savedFullName = 'Socio';

  @override
  void initState() {
    super.initState();
    _checkSavedBiometrics();
  }

  Future<void> _checkSavedBiometrics() async {
    if (kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('use_biometrics') ?? false;
    if (saved && mounted) {
      final savedUser = prefs.getString('saved_username');
      final savedName = prefs.getString('saved_user_fullname') ?? 'Socio';
      if (savedUser != null) _userController.text = savedUser;
      
      setState(() {
        _hasBiometricsSaved = true;
        _savedFullName = savedName;
      });
      
      // Auto-trigger biometric authentication if saved
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authenticateWithBiometrics();
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (kIsWeb) return;
    try {
      final isAvailable = await _localAuth.canCheckBiometrics() || await _localAuth.isDeviceSupported();
      if (!isAvailable) return;

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Inicia sesión con tu Face ID o Huella Digital',
      );

      if (didAuthenticate && mounted) {
        setState(() => _isLoading = true);
        final prefs = await SharedPreferences.getInstance();
        final savedRefreshToken = prefs.getString('saved_refresh_token');

        if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
          ToastAlerts.showWarning(context, 'Tu sesión ha expirado, inicia sesión con código por favor.');
          setState(() => _isLoading = false);
          return;
        }

        try {
          // Solicitar un nuevo access token usando el refresh token al backend
          final dio = ref.read(apiClientProvider).dio;
          final response = await dio.post(
            ApiEndpoints.refreshSocio,
            data: {'refresh_token': savedRefreshToken},
          );

          if (mounted) {
            final userData = response.data['data']['socio'];
            final memberType = (userData['app_role'] ?? 'titular').toString();
            final permissions = List<String>.from(response.data['data']['permissions'] ?? []);
            final accessToken = response.data['data']['access_token'];
            final newRefreshToken = response.data['data']['refresh_token'];
            final username = userData['entityid'] ?? '';
            final savedId = userData['id'].toString();

            // Guardar el nuevo refresh token
            if (newRefreshToken != null) {
              await prefs.setString('saved_refresh_token', newRefreshToken);
            }

            // Actualizar token en ApiClient mutable (DEBE SER PRIMERO)
            ref.read(apiClientNotifierProvider.notifier).updateToken(accessToken);

            ref.read(authProvider.notifier).setLoggedInMember(
              Member(
                id: savedId,
                membershipNumber: username,
                firstName: userData['fullname'] ?? 'Socio',
                lastName: '',
                secondLastName: '',
                memberType: memberType,
                isTitular: memberType.toLowerCase() == 'titular' || memberType == '1',
                token: accessToken,
                permissions: permissions,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          }
        } on DioException catch (e) {
          if (mounted) {
            ToastAlerts.showError(context, 'Por seguridad, debes iniciar sesión de nuevo.');
            await prefs.setBool('use_biometrics', false);
            setState(() {
              _isLoading = false;
              _hasBiometricsSaved = false;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error using biometrics: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestWhatsAppCode() async {
    final username = _userController.text.trim();
    if (username.isEmpty) {
      ToastAlerts.showWarning(context, 'Ingresa tu número de membresía primero');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final dio = ref.read(apiClientProvider).dio;
      final response = await dio.post(
        ApiEndpoints.requestAppCode,
        data: {'username': username},
      );
      
      if (mounted) {
        setState(() => _codeSent = true);
        String codeMsg = 'Código enviado por WhatsApp';
        String? mockCode;
        if (response.data is Map && response.data['data'] != null && response.data['data']['mock_code'] != null) {
          mockCode = response.data['data']['mock_code'].toString();
          // Eliminado `codeMsg += ' (Código: $mockCode)';` para no revelarlo en el UI
        }
        
        ToastAlerts.showSuccess(
          context, 
          codeMsg,
          onTap: mockCode != null ? () {
             setState(() {
               _passwordController.text = mockCode!;
             });
          } : null
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMsg = e.response?.data['message'] ?? e.message ?? 'Error al solicitar código';
        ToastAlerts.showError(context, errorMsg);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final username = _userController.text.trim();
      final password = _passwordController.text;

      try {
        final dio = ref.read(apiClientProvider).dio;
        final response = await dio.post(
          ApiEndpoints.loginAppCode,
          data: {
            'username': username,
            'password': password,
            'app_client': 'member_mobile',
          },
        );

        if (mounted) {
          final userData = response.data['data']['socio'] ?? response.data['data']['user'];
          final memberType = (userData['role'] ?? userData['app_role'] ?? 'titular').toString();
          final permissions = List<String>.from(response.data['data']['permissions'] ?? []);

          final mainId = userData['entityid'] ?? userData['username'] ?? username;

          String fName = userData['first_name']?.toString().trim() ?? '';
          if (fName.isEmpty) {
            fName = userData['fullname']?.toString().trim() ?? 'Usuario';
          }
          final parts = fName.split(' ');
          while (parts.isNotEmpty && int.tryParse(parts.first) != null) {
            parts.removeAt(0);
          }
          fName = parts.isNotEmpty ? parts.join(' ') : 'Socio';

          final mappedMember = Member(
            id: userData['id'].toString(),
            membershipNumber: mainId,
            firstName: fName,
            lastName: userData['last_name']?.toString().trim() ?? '',
            secondLastName: '',
            memberType: memberType,
            isTitular: memberType.toLowerCase() == 'titular' || memberType == '1',
            email: userData['email'],
            phone: userData['phone'],
            token: response.data['data']['access_token'],
            permissions: permissions,
          );
          // 1. Actualizar token en ApiClient mutable (DEBE SER PRIMERO)
          ref.read(apiClientNotifierProvider.notifier).updateToken(response.data['data']['access_token']);

          // 2. Notificar al sistema del nuevo usuario. El AuthNotifier ahora guarda automáticamente en SharedPreferences.
          ref.read(authProvider.notifier).setLoggedInMember(mappedMember);

          final prefs = await SharedPreferences.getInstance();
          final isAvailable = !kIsWeb && (await _localAuth.canCheckBiometrics() || await _localAuth.isDeviceSupported());
          if (isAvailable) {
            await prefs.setBool('use_biometrics', true);
            await prefs.setString('saved_username', mainId);
            await prefs.setString('saved_user_fullname', fName);
          }
          if (response.data['data']['refresh_token'] != null) {
            await prefs.setString('saved_refresh_token', response.data['data']['refresh_token']);
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          String errorMsg = e.response?.data['message'] ?? e.message ?? 'Credenciales incorrectas';
          ToastAlerts.showError(context, errorMsg);
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.neutral900 : AppTheme.neutral50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Card(
                    elevation: isDark ? 0 : 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingLarge),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                isDark ? 'assets/images/CENTRO_LIBANES_LOGO_NEGRO.png' : 'assets/images/logo-centro-libanes.png',
                                height: 90,
                                errorBuilder: (c, e, s) => const Icon(Icons.account_balance_wallet, size: 60, color: AppTheme.primaryColor),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLarge),
                            Text(
                              'Ecosistema Centro Libanés',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isDark ? AppTheme.neutral200 : AppTheme.neutral500,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLarge * 1.5),
                            
                            if (_hasBiometricsSaved && !_codeSent) ...[
                              Text(
                                '¡Hola de nuevo, $_savedFullName!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingLarge),
                              ElevatedButton.icon(
                                onPressed: _isLoading ? null : _authenticateWithBiometrics,
                                icon: const Icon(Icons.fingerprint, size: 28),
                                label: _isLoading 
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Text('Ingresar con Biometría', style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingMedium),
                              TextButton(
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setBool('use_biometrics', false);
                                  setState(() {
                                    _hasBiometricsSaved = false;
                                    _userController.clear();
                                  });
                                },
                                child: const Text('Ingresar con otra cuenta'),
                              ),
                            ] else ...[
                              if (!_codeSent && !_useTempPasswordLogin)
                                TextFormField(
                                  controller: _userController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Membresía',
                                    helperText: 'Número de Membresía a 7 dígitos',
                                    prefixIcon: Icon(Icons.badge_outlined, size: 20),
                                  ),
                                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                                )
                              else if (_useTempPasswordLogin)
                                TextFormField(
                                  controller: _userController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Membresía o Usuario',
                                    prefixIcon: Icon(Icons.badge_outlined, size: 20),
                                  ),
                                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                                )
                              else
                                Card(
                                  elevation: 0,
                                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                  child: ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.person_pin_circle_outlined),
                                    title: Text(
                                      _userController.text,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    trailing: TextButton(
                                      child: const Text("Editar"),
                                      onPressed: () => setState(() => _codeSent = false),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: AppTheme.spacingMedium),

                              if (_codeSent || _useTempPasswordLogin) ...[
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: _useTempPasswordLogin ? 'Contraseña' : 'Código WhatsApp',
                                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  validator: (v) => v == null || v.isEmpty ? (_useTempPasswordLogin ? 'Introduce la contraseña' : 'Introduce el código') : null,
                                ),
                                const SizedBox(height: AppTheme.spacingLarge),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _handleLogin,
                                    child: _isLoading ? const CircularProgressIndicator() : const Text('Iniciar Sesión'),
                                  ),
                                  const SizedBox(height: AppTheme.spacingMedium),
                                  if (!_useTempPasswordLogin)
                                    TextButton(
                                      onPressed: _isLoading ? null : _requestWhatsAppCode,
                                      child: const Text('¿No recibiste el código? Reenviar'),
                                    ),
                                ] else ...[
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _requestWhatsAppCode,
                                  child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Continuar y Recibir Código'),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  const Text('© 2026 ArzSuite. Todos los derechos reservados.', style: TextStyle(color: AppTheme.neutral400, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
