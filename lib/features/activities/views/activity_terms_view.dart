import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';

class ActivityTermsView extends StatefulWidget {
  final VoidCallback onAccept;

  const ActivityTermsView({super.key, required this.onAccept});

  @override
  State<ActivityTermsView> createState() => _ActivityTermsViewState();
}

class _ActivityTermsViewState extends State<ActivityTermsView> {
  bool _hasScrolledToBottom = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
        if (!_hasScrolledToBottom) {
          setState(() {
            _hasScrolledToBottom = true;
          });
        }
      }
    });

    // En caso de que el texto sea corto y no necesite scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent <= 0) {
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral50,
      appBar: AppBar(
        title: const Text('Términos y Condiciones v1.2'), // Versionado
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: ResponsiveContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingLarge),
                    Text(
                      'Acuerdo de Participación Deportiva',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.neutral900,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    const Text(
                      'Por favor lea detenidamente el siguiente documento. Al aceptar, usted reconoce y acepta todos los riesgos inherentes de la actividad física...',
                      style: TextStyle(color: AppTheme.neutral700, height: 1.6),
                    ),
                    SizedBox(height: 1000), // Simula un documento largo
                    const Text(
                      'Fin del documento. Debe leer hasta el final para habilitar el botón de aceptar.',
                      style: TextStyle(color: AppTheme.neutral700, height: 1.6),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasScrolledToBottom ? widget.onAccept : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLarge),
                  ),
                  child: Text(
                    _hasScrolledToBottom ? 'Aceptar y Firmar Digitalmente' : 'Baje para leer todo',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
