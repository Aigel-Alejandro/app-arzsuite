import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/network/api_endpoints.dart';
import 'package:app_arzsuite/core/providers/global_providers.dart';
import '../../home/views/home_view.dart';
import '../../../core/providers/auth_provider.dart';
import '../../summer_course/models/member.dart';
/// Pantalla de login moderna con estética tipo Pinterest.
/// Diseño limpio, minimalista, con colores sólidos y una tarjeta central.
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

  @override
  void initState() {
    super.initState();
    // Credenciales por defecto para pruebas locales
    _userController.text = 'admin';
    _passwordController.text = 'Sistema!Centro2026';
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final username = _userController.text.trim();
      final password = _passwordController.text;

      // BYPASS LOCAL: Credenciales de admin para pruebas rápidas
      if (username == 'admin' && password == 'Sistema!Centro2026') {
        if (mounted) {
          ref.read(authProvider.notifier).setLoggedInMember(
            Member(
              id: '1234500',
              membershipNumber: '1234500',
              firstName: 'JOSE ARTURO',
              lastName: 'FEREZ',
              secondLastName: 'VIDAL',
              memberType: 'Titular',
              isTitular: true,
            ),
          );
           Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
        return;
      }

      try {
        final dio = ref.read(apiClientProvider).dio;
        // Petición al Sitio 2 enviando el contexto "app_client" para que actúe en consecuencia
        final response = await dio.post(
          ApiEndpoints.login,
          data: {
            'username': username,
            'password': password,
            'app_client': 'member_mobile', // Identificador del Sitio 3
          },
        );

        if (mounted) {
          final mappedMember = Member(
            id: '1234500', // En caso real: response.data['user']['id'],
            membershipNumber: username,
            firstName: 'Usuario',
            lastName: 'Socio',
            secondLastName: '',
            memberType: 'Titular',
            isTitular: true,
          );
          ref.read(authProvider.notifier).setLoggedInMember(mappedMember);

          // Navegar a la pantalla de Home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          // Manejo de errores 401, 404, etc.
          String errorMsg = e.message ?? 'Error de red';
          if (e.response != null && e.response?.data is Map) {
             errorMsg = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Credenciales incorrectas';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error: $errorMsg'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error inesperado: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si estamos en modo oscuro para ajustar el brillo sutilmente
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.neutral900 : AppTheme.neutral50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacingLarge,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CARD Central estilo Pinterest
                  Card(
                    elevation: isDark ? 0 : 5,
                    shadowColor: Colors.black.withOpacity(0.05),
                    color: Theme.of(context).cardTheme.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLarge,
                        vertical: AppTheme.spacingLarge * 1.5,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // LOGO ASSET
                            Center(
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                                ),
                                child: Image.asset(
                                  'assets/images/logo-centro-libanes.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.account_balance_wallet,
                                          size: 60, color: AppTheme.primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLarge),
                            
                            // TITULO Y MENSAJE
                            Text(
                              'Ecosistema Centro Libanés',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.neutral500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLarge * 1.5),

                            // INPUT USUARIO
                            TextFormField(
                              controller: _userController,
                              style: const TextStyle(fontSize: 15),
                              decoration: const InputDecoration(
                                labelText: 'Usuario o Correo',
                                prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),

                            // INPUT CONTRASEÑA
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: AppTheme.neutral500,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: AppTheme.spacingLarge),

                            // BOTÓN ENTRAR (SOLID)
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                elevation: 0, // Pinterest-like flat look for buttons
                              ),
                              child: _isLoading 
                                ? const SizedBox(
                                    height: 24, 
                                    width: 24, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  )
                                : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.spacingMedium),
                            
                            // RECUPERACIÓN SUTIL
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                '¿Tienes problemas para entrar?',
                                style: TextStyle(
                                  color: AppTheme.neutral500,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // FOOTER EXTERNO AL CARD
                  const SizedBox(height: AppTheme.spacingLarge),
                  Text(
                    '© 2026 ArzSuite. Todos los derechos reservados.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral400,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
