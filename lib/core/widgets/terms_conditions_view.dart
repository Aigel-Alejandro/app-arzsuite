import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';

class TermsConditionsView extends StatefulWidget {
  final VoidCallback onAccept;
  final String title;
  final String content;
  final String version;

  const TermsConditionsView({
    super.key, 
    required this.onAccept, 
    required this.title,
    required this.content,
    required this.version,
  });

  @override
  State<TermsConditionsView> createState() => _TermsConditionsViewState();
}

class _TermsConditionsViewState extends State<TermsConditionsView> {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('${widget.title} v${widget.version}'),
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
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.neutral900,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    Text(
                      widget.content,
                      style: const TextStyle(color: AppTheme.neutral700, height: 1.6),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
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
                  onPressed: _hasScrolledToBottom ? () {
                    widget.onAccept();
                  } : null,
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
