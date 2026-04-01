import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import '../services/summer_course_service.dart';

class SummerCourseScannerView extends ConsumerStatefulWidget {
  const SummerCourseScannerView({super.key});

  @override
  ConsumerState<SummerCourseScannerView> createState() => _SummerCourseScannerViewState();
}

class _SummerCourseScannerViewState extends ConsumerState<SummerCourseScannerView> {
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _validationData;

  Future<void> _validateToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) return;

    setState(() {
      _isLoading = true;
      _validationData = null;
    });

    final service = ref.read(summerCourseServiceProvider);
    final data = await service.validateToken(token);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _validationData = data;
      });
      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Token inválido o expirado'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _process(String type) async {
    if (_validationData == null) return;
    
    setState(() => _isLoading = true);
    final service = ref.read(summerCourseServiceProvider);
    final success = await service.processAttendance(_tokenController.text.trim(), type);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(type == 'check_in' ? 'Check-in exitoso' : 'Check-out exitoso'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        setState(() {
          _validationData = null;
          _tokenController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al procesar la asistencia'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Acceso', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.qr_code_scanner_rounded, size: 80, color: AppTheme.secondaryColor),
            const SizedBox(height: 16),
            const Text(
              'Escáner del Instructor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Escanea el QR del padre para registrar llegada/salida',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'Ingresa Token Manual',
                hintText: 'Ej. XXYYYZZZ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: _isLoading ? null : _validateToken,
                ),
              ),
              onSubmitted: (_) => _validateToken(),
            ),
            const SizedBox(height: 40),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_validationData != null)
              _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final msg = _validationData!['message'] ?? 'Autorizado';
    final participants = _validationData!['data'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.1),
        border: Border.all(color: AppTheme.successColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.successColor, size: 48),
          const SizedBox(height: 16),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...participants.map((p) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_rounded),
            title: Text(p['name'] ?? 'Participante', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(p['type'] ?? ''),
          )),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _process('check_in'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                  icon: const Icon(Icons.login_rounded, color: Colors.white),
                  label: const Text('CHECK IN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _process('check_out'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text('CHECK OUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
