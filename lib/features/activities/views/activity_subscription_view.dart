import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/activity_terms_view.dart';

class ActivitySubscriptionView extends StatefulWidget {
  const ActivitySubscriptionView({super.key});

  @override
  State<ActivitySubscriptionView> createState() => _ActivitySubscriptionViewState();
}

class _ActivitySubscriptionViewState extends State<ActivitySubscriptionView> {
  String? _selectedBeneficiary;
  bool _termsAccepted = false;

  void _onTermsAccepted(bool accepted) {
    setState(() {
      _termsAccepted = accepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeIndex: 1,
      child: Scaffold(
        backgroundColor: AppTheme.neutral50,
        appBar: AppBar(
          title: const Text('Inscripción a Actividad'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingLarge),
                Text(
                  'Fútbol Infantil (Sub-12)',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.neutral900,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                const Text(
                  'Selecciona el beneficiario para inscribir en la actividad. Capacidad disponible: 5 lugares.',
                  style: TextStyle(color: AppTheme.neutral600),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
  
                // Selector de Menores/Beneficiarios
                Text(
                  'Beneficiario',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutral900,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                    border: Border.all(color: AppTheme.neutral300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Seleccionar a un menor a cargo'),
                      value: _selectedBeneficiary,
                      items: ['Juanito Pérez', 'María Pérez'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBeneficiary = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
  
                // Términos y Condiciones
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _termsAccepted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        color: _termsAccepted ? AppTheme.successColor : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacingMedium),
                      Expanded(
                        child: Text(
                          _termsAccepted ? 'Términos aceptados v1.2' : 'Requiere aceptación de términos para continuar.',
                          style: TextStyle(
                            color: _termsAccepted ? AppTheme.successColor : AppTheme.neutral900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!_termsAccepted)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                                pageBuilder: (_, __, ___) => ActivityTermsView(
                                  onAccept: () {
                                    _onTermsAccepted(true);
                                    Navigator.pop(context); // Vuelve a esta pantalla
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Leer', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                ),
  
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedBeneficiary != null && _termsAccepted)
                        ? () {
                            // Acción de suscripción
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Inscripción exitosa. Se notificó al backend.')),
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLarge),
                    ),
                    child: const Text('Confirmar Inscripción', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
