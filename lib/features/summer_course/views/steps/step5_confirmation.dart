import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/summer_course_state.dart';

class Step5Confirmation extends ConsumerWidget {
  const Step5Confirmation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    if (state.salesOrderId != null) {
      return _buildSuccess(context, state, notifier, state.salesOrderId!, state.pickUpTokens);
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
                color: AppTheme.neutral600,
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
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Por favor, verifica que la información sea correcta antes de finalizar tu inscripción.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
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
              color: AppTheme.neutral400,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.neutral100,
                  child: const Icon(Icons.person_rounded, color: AppTheme.neutral600, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.selectedTitular?.fullName ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.neutral900, fontSize: 15),
                      ),
                      Text(
                        'Acción: ${state.selectedTitular?.membershipNumber}  •  ${state.selectedTitular?.memberType ?? ''}',
                        style: const TextStyle(color: AppTheme.neutral500, fontSize: 12, fontWeight: FontWeight.w600),
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
              color: AppTheme.neutral500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          ...state.selectedParticipants.map((p) {
             return Padding(
               padding: const EdgeInsets.only(bottom: 8),
               child: _buildSummaryCard(
                 child: Row(
                   children: [
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.neutral800, fontSize: 13)),
                           Text(
                             '${p.isSocio ? 'Socio' : 'Invitado'}  •  ${p.selectedWeekIds.length} semanas',
                             style: TextStyle(
                               color: p.isSocio ? AppTheme.primaryColor : AppTheme.vibrantGold, 
                               fontSize: 11, 
                               fontWeight: FontWeight.bold
                             ),
                           ),
                         ],
                       ),
                     ),
                     Text(
                       formatter.format(p.totalCost), 
                       style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.neutral900, fontSize: 16)
                     ),
                   ],
                 ),
               ),
             );
          }),

          const SizedBox(height: 24),

          const Divider(height: 48, color: AppTheme.neutral200),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL A PAGAR', 
                style: TextStyle(
                  fontWeight: FontWeight.w900, 
                  fontSize: 12, 
                  color: AppTheme.neutral500,
                  letterSpacing: 1.2,
                )
              ),
              Text(
                formatter.format(state.totalGeneral), 
                style: const TextStyle(
                  color: AppTheme.primaryColor, 
                  fontWeight: FontWeight.w900, 
                  fontSize: 32,
                )
              ),
            ],
          ),

          const SizedBox(height: 40),
          
          if (state.errorMessage != null)
            _buildErrorWidget(state.errorMessage!),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutral200.withOpacity(0.8)),
        boxShadow: [
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

  Widget _buildErrorWidget(String error) {
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
  }  Widget _buildSuccess(BuildContext context, SummerCourseState state, SummerCourseNotifier notifier, String orderId, List<dynamic>? pickUpTokens) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F9FA), // Un gris muy tenue de fondo
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900),
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu registro se ha completado. Hemos generado la orden de venta en nuestro sistema.',
              style: TextStyle(color: AppTheme.neutral500, fontSize: 14, height: 1.4),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),

            // RECETA / TICKET DIGITAL
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
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
                      color: AppTheme.neutral900,
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
                            const Text('CÓDIGO DE RECOLECCIÓN', style: TextStyle(color: AppTheme.neutral400, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.successColor.withOpacity(0.2), width: 1.5, style: BorderStyle.none), // Border dashed simulado? No, sólido fino
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
                            const Text(
                              'Presenta este código digital para recoger a los alumnos.',
                              style: TextStyle(fontSize: 12, color: AppTheme.neutral500, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          
                          const Divider(height: 40, color: AppTheme.neutral100),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Participantes', style: TextStyle(color: AppTheme.neutral500, fontWeight: FontWeight.bold)),
                              Text('${state.selectedParticipants.length}', style: const TextStyle(fontWeight: FontWeight.w900)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Pagado', style: TextStyle(color: AppTheme.neutral500, fontWeight: FontWeight.bold)),
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

            const SizedBox(height: 48),
            
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      elevation: 0,
                    ),
                    child: const Text('FINALIZAR Y SALIR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => notifier.reset(),
                  child: const Text('Realizar otra inscripción', style: TextStyle(color: AppTheme.neutral500, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

