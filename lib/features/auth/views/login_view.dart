import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/core/network/api_endpoints.dart';
import 'package:app_arzsuite/core/providers/global_providers.dart';
import '../../home/views/home_view.dart';
import '../../../core/providers/auth_provider.dart';
import '../../summer_course/models/member.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _codeSent = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _hasBiometricsSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSavedBiometrics();
  }

  Future<void> _checkSavedBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('use_biometrics') ?? false;
    if (saved && mounted) {
      setState(() => _hasBiometricsSaved = true);
      final savedUser = prefs.getString('saved_username');
      if (savedUser != null) _userController.text = savedUser;
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!isAvailable) return;

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Inicia sesión con tu Face ID o Huella Digital',
      );

      if (didAuthenticate && mounted) {
        final prefs = await SharedPreferences.getInstance();
        final savedUser = prefs.getString('saved_username') ?? '';
        final savedToken = prefs.getString('saved_token');

        final savedMemberType = prefs.getString('saved_member_type') ?? 'Titular';
        final savedPermissions = prefs.getStringList('saved_permissions') ?? [];
        final savedId = prefs.getString('saved_id') ?? '0';

        // Actualizar token en ApiClient mutable (DEBE SER PRIMERO)
        if (savedToken != null) {
          ref.read(apiClientNotifierProvider.notifier).updateToken(savedToken);
        }

        ref.read(authProvider.notifier).setLoggedInMember(
          Member(
            id: savedId,
            membershipNumber: savedUser,
            firstName: 'Socio',
            lastName: 'Identificado',
            secondLastName: '',
            memberType: savedMemberType,
            isTitular: savedMemberType.toLowerCase() == 'titular',
            token: savedToken,
            permissions: savedPermissions,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    } catch (e) {
      debugPrint('Error using biometrics: $e');
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
        String errorMsg = e.response?.data['message'] ?? 'Error al solicitar código';
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
          final memberType = userData['role'] ?? userData['app_role'] ?? 'titular';
          final permissions = List<String>.from(response.data['data']['permissions'] ?? []);

          final mainId = userData['entityid'] ?? userData['username'] ?? username;

          String fName = userData['first_name']?.toString().trim() ?? '';
          if (fName.isEmpty) {
            fName = userData['fullname']?.toString().trim() ?? 'Usuario';
          }
          if (int.tryParse(fName.split(' ').first) != null) {
            fName = 'Socio';
          }

          final mappedMember = Member(
            id: userData['id'].toString(),
            membershipNumber: mainId,
            firstName: fName,
            lastName: userData['last_name']?.toString().trim() ?? '',
            secondLastName: '',
            memberType: memberType,
            isTitular: memberType.toLowerCase() == 'titular',
            email: userData['email'],
            phone: userData['phone'],
            token: response.data['data']['access_token'],
            permissions: permissions,
          );
          // 1. Actualizar token en ApiClient mutable (DEBE SER PRIMERO)
          ref.read(apiClientNotifierProvider.notifier).updateToken(response.data['data']['access_token']);

          // 2. Notificar al sistema del nuevo usuario. El AuthNotifier ahora guarda automáticamente en SharedPreferences.
          ref.read(authProvider.notifier).setLoggedInMember(mappedMember);

          if (_rememberMe) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('use_biometrics', true);
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          String errorMsg = e.response?.data['message'] ?? 'Credenciales incorrectas';
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
                                'assets/images/logo-centro-libanes.png',
                                height: 90,
                                errorBuilder: (c, e, s) => const Icon(Icons.account_balance_wallet, size: 60, color: AppTheme.primaryColor),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLarge),
                            Text(
                              'Ecosistema Centro Libanés',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.neutral500),
                            ),
                            const SizedBox(height: AppTheme.spacingLarge * 1.5),
                            
                            if (!_codeSent)
                              TextFormField(
                                controller: _userController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Número de Membresía',
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

                            if (_codeSent) ...[
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Código WhatsApp',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) => v == null || v.isEmpty ? 'Introduce el código' : null,
                              ),
                              const SizedBox(height: AppTheme.spacingLarge),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  child: _isLoading ? const CircularProgressIndicator() : const Text('Verificar e Iniciar Sesión'),
                                ),
                                const SizedBox(height: AppTheme.spacingMedium),
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

                            const SizedBox(height: AppTheme.spacingMedium),
                            CheckboxListTile(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              title: const Text('Recordarme y usar Biometría', style: TextStyle(fontSize: 13)),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                            
                            if (_hasBiometricsSaved && !_codeSent) ...[
                              OutlinedButton.icon(
                                onPressed: _authenticateWithBiometrics,
                                icon: const Icon(Icons.fingerprint),
                                label: const Text('Ingresar con Biometría'),
                              ),
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
