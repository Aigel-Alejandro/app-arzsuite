import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/summer_course_state.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_token_provider.dart';
import 'package:app_arzsuite/features/summer_course/providers/active_registration_provider.dart';
import 'package:app_arzsuite/core/widgets/terms_conditions_view.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:url_launcher/url_launcher.dart';

class Step5Confirmation extends ConsumerWidget {
  const Step5Confirmation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.neutral100 : AppTheme.neutral900;
    final subTextColor = isDark ? AppTheme.neutral400 : AppTheme.neutral600;

    if (state.salesOrderId != null) {
      return _buildSuccess(context, state, notifier, state.salesOrderId!, state.pickUpTokens, ref);
    }

    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 3),
            const SizedBox(height: 24),
            Text(
              'Generando Orden en NetSuite...',
              style: TextStyle(
                color: subTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmación Final',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Por favor, verifica que la información sea correcta antes de finalizar tu inscripción.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                  height: 1.4,
                ),
          ),
          
          const SizedBox(height: 32),

          // Titular Summary Card
          Text(
            'TITULAR RESPONSABLE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isDark ? AppTheme.neutral500 : AppTheme.neutral400,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryCard(
            context,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isDark ? AppTheme.neutral700 : AppTheme.neutral100,
                  child: Icon(Icons.person_rounded, color: isDark ? AppTheme.neutral300 : AppTheme.neutral600, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (state.selectedTitular?.fullName ?? 'N/A').replaceAll(RegExp(r'[0-9]'), '').trim(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 15),
                      ),
                      Text(
                        'Acción: ${state.selectedTitular?.membershipNumber}  •  ${state.selectedTitular?.memberType ?? ''}',
                        style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Text(
            'PARTICIPANTES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: isDark ? AppTheme.neutral500 : AppTheme.neutral500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          ...state.selectedParticipants.map((p) {
             return Padding(
               padding: const EdgeInsets.only(bottom: 8),
               child: _buildSummaryCard(
                 context,
                 child: Row(
                   children: [
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(p.fullName, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 13)),
                           Text(
                             '${p.isSocio ? 'Socio' : 'Invitado'}  •  ${p.selectedWeekIds.length} semanas',
                             style: TextStyle(
                               color: p.isSocio ? AppTheme.primaryColor : AppTheme.vibrantGold, 
                               fontSize: 11, 
                               fontWeight: FontWeight.bold
                             ),
                           ),
                           if (p.intensiveActivityId != null && state.intensiveActivities.isNotEmpty) ...[
                             const SizedBox(height: 4),
                             Text(
                               'Verano intensivo: ${state.intensiveActivities.firstWhere((a) => a['id'] == p.intensiveActivityId, orElse: () => <String, dynamic>{})['name'] ?? ''}',
                               style: const TextStyle(
                                 color: AppTheme.successColor,
                                 fontSize: 11,
                                 fontWeight: FontWeight.w900,
                               ),
                             ),
                           ],
                         ],
                       ),
                     ),
                     Text(
                       formatter.format(p.totalCost), 
                       style: TextStyle(fontWeight: FontWeight.w900, color: textColor, fontSize: 16)
                     ),
                   ],
                 ),
               ),
             );
          }),

          const SizedBox(height: 24),

          Divider(height: 48, color: isDark ? AppTheme.neutral700 : AppTheme.neutral200),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL A PAGAR', 
                style: TextStyle(
                  fontWeight: FontWeight.w900, 
                  fontSize: 12, 
                  color: isDark ? AppTheme.neutral400 : AppTheme.neutral500,
                  letterSpacing: 1.2,
                )
              ),
              Expanded(
                child: Text(
                  formatter.format(state.totalGeneral), 
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.primaryColor, 
                    fontWeight: FontWeight.w900, 
                    fontSize: 26,
                  )
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (state.termsRequired)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.neutral800 : AppTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                border: Border.all(color: isDark ? AppTheme.neutral700 : AppTheme.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    state.termsAccepted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                    color: state.termsAccepted ? AppTheme.successColor : AppTheme.primaryColor,
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: Text(
                      state.termsAccepted ? 'Términos aceptados' : 'Debe aceptar los términos del Curso de Verano.',
                      style: TextStyle(
                        color: state.termsAccepted ? AppTheme.successColor : textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (!state.termsAccepted)
                    ElevatedButton(
                      onPressed: () {
                        if (state.termsContent == null) return;
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                            pageBuilder: (_, __, ___) => TermsConditionsView(
                              title: 'Términos - Curso Verano',
                              version: state.termsVersion ?? '1',
                              content: state.termsContent!,
                              onAccept: () async {
                                bool ok = await notifier.acceptTerms();
                                if (ok && context.mounted) {
                                  Navigator.pop(context);
                                } else if (context.mounted) {
                                  ToastAlerts.showError(context, 'Error al aceptar los términos');
                                }
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

          const SizedBox(height: 40),
          
          if (state.errorMessage != null)
            _buildErrorWidget(context, state.errorMessage!),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppTheme.neutral700 : AppTheme.neutral200.withOpacity(0.8)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dangerColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dangerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppTheme.dangerColor),
          const SizedBox(width: 12),
          Expanded(child: Text(error, style: const TextStyle(color: AppTheme.dangerColor))),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, SummerCourseState state, SummerCourseNotifier notifier, String orderId, List<dynamic>? pickUpTokens, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      color: isDark ? AppTheme.neutral900 : const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ICONO DE ÉXITO ANIMADO (SIMULADO)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppTheme.successColor, size: 80),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Inscripción Exitosa!', 
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900, 
                color: isDark ? AppTheme.neutral100 : AppTheme.neutral900
              ),
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 8),
            Text(
              'Tu registro se ha completado. Hemos generado la orden de venta en nuestro sistema.',
              style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontSize: 14, height: 1.4),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),

            // RECETA / TICKET DIGITAL
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.neutral800 : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    // Parte Superior del Ticket
                    Container(
                      padding: const EdgeInsets.all(24),
                      color: isDark ? AppTheme.neutral900.withOpacity(0.5) : AppTheme.neutral900,
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text('ID DE ORDEN NETSUITE', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                          const SizedBox(height: 4),
                          Text(orderId, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    
                    // Cuerpo del Ticket
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          if (state.masterToken != null) ...[
                            Text('CÓDIGO DE RECOLECCIÓN', style: TextStyle(color: isDark ? AppTheme.neutral500 : AppTheme.neutral400, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.successColor.withOpacity(0.2), width: 1.5, style: BorderStyle.none),
                              ),
                              child: Text(
                                state.masterToken!,
                                style: const TextStyle(
                                  fontSize: 42, 
                                  fontWeight: FontWeight.w900, 
                                  letterSpacing: 8, 
                                  color: AppTheme.successColor
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Presenta este código digital para recoger a los alumnos.',
                              style: TextStyle(fontSize: 12, color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          
                          Divider(height: 40, color: isDark ? AppTheme.neutral700 : AppTheme.neutral100),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Participantes', style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontWeight: FontWeight.bold)),
                              Text('${state.selectedParticipants.length}', style: TextStyle(fontWeight: FontWeight.w900, color: isDark ? AppTheme.neutral200 : AppTheme.neutral900)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total a Pagar', style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontWeight: FontWeight.bold)),
                              Text(NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(state.totalGeneral), style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // KarloPay Action Box
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.neutral800 : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(color: AppTheme.primaryColor.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ]
              ),
              child: Column(
                children: [
                  const Icon(Icons.payment_rounded, color: AppTheme.primaryColor, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Completa tu pago',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: isDark ? AppTheme.neutral100 : AppTheme.neutral900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¡Hola! Aquí tienes los detalles para realizar tu pago de forma segura. Puedes realizarlo en caja, kiosko o a través del portal de KarloPay en el siguiente enlace:',
                    style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontSize: 13, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse('https://cartera.karlopay.com/auth/login');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Ir a KarloPay', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.invalidate(activeRegistrationProvider);
                      ref.invalidate(summerCourseTokenProvider);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppTheme.neutral300 : AppTheme.neutral700,
                      side: BorderSide(color: isDark ? AppTheme.neutral700 : AppTheme.neutral300),
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    child: const Text('FINALIZAR Y SALIR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => notifier.reset(),
                  child: Text('Realizar otra inscripción', style: TextStyle(color: isDark ? AppTheme.neutral400 : AppTheme.neutral500, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


