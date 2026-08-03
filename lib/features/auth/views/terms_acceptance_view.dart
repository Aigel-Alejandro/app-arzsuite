import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/global_providers.dart';
import '../../../core/providers/auth_provider.dart';

class TermsAcceptanceView extends ConsumerStatefulWidget {
  const TermsAcceptanceView({super.key});

  @override
  ConsumerState<TermsAcceptanceView> createState() => _TermsAcceptanceViewState();
}

class _TermsAcceptanceViewState extends ConsumerState<TermsAcceptanceView> {
  bool _isLoading = false;

  Future<void> _launchPrivacyPolicy() async {
    final url = Uri.parse('https://www.centrolibanes.org.mx/index.php/avisos-de-privacidad');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
      }
    }
  }

  Future<void> _acceptTerms() async {
    setState(() => _isLoading = true);
    
    try {
      final client = ref.read(apiClientProvider);
      final response = await client.dio.post('arzsuite/profile/accept-terms', data: {});
      
      if (response.statusCode == 200) {
        ref.read(authProvider.notifier).acceptTerms();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al aceptar los términos: ${response.data['message'] ?? ''}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    ref.read(authProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevent going back
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              const Text(
                'Aviso de Privacidad',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para continuar usando la aplicación, por favor lee y acepta nuestro Aviso de Privacidad y Términos y Condiciones.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: _launchPrivacyPolicy,
                icon: const Icon(Icons.open_in_new),
                label: const Text(
                  'Leer Aviso de Privacidad',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _acceptTerms,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'He leído y Acepto',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _logout,
                child: const Text(
                  'Cancelar y Cerrar Sesión',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
