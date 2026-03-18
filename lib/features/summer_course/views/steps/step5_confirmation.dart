import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';

class Step5Confirmation extends ConsumerWidget {
  const Step5Confirmation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    if (state.salesOrderId != null) {
      return _buildSuccess(context, state.salesOrderId!);
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
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centrado como en la imagen
        children: [
          Text(
            'Confirmar Inscripción',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.secondaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revisa los datos antes de generar la orden',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                ),
          ),
          
          const SizedBox(height: 32),

          // Titular Summary Card
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Socio Titular',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.secondaryColor,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre: ${state.selectedTitular?.fullName ?? 'N/A'}',
                  style: const TextStyle(color: AppTheme.neutral700, fontSize: 15),
                ),
                Text(
                  'Membresía: ${state.selectedTitular?.membershipNumber}',
                  style: const TextStyle(color: AppTheme.neutral700, fontSize: 15),
                ),
                Text(
                  'Tipo: ${state.selectedTitular?.memberType ?? 'N/A'}',
                  style: const TextStyle(color: AppTheme.neutral700, fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Participantes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.secondaryColor,
                  ),
            ),
          ),
          const SizedBox(height: 16),

          ...state.selectedParticipants.map((p) {
             return Padding(
               padding: const EdgeInsets.only(bottom: 12),
               child: _buildSummaryCard(
                 child: Row(
                   children: [
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.secondaryColor, fontSize: 16)),
                           const SizedBox(height: 4),
                           Text(
                             p.isSocio ? 'Socio' : 'Invitado', 
                             style: const TextStyle(color: AppTheme.neutral500, fontSize: 12, fontWeight: FontWeight.bold)
                           ),
                           Text(
                             p.selectedWeekIds.map((id) => 'Semana $id').join(', '),
                             style: const TextStyle(color: AppTheme.neutral600, fontSize: 12),
                           ),
                         ],
                       ),
                     ),
                     Text(
                       formatter.format(p.totalCost), 
                       style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.secondaryColor, fontSize: 18)
                     ),
                   ],
                 ),
               ),
             );
          }),

          const SizedBox(height: 32),
          const Divider(height: 1, color: AppTheme.neutral200),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF2EBE0), // Beige background
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              border: Border.all(color: AppTheme.primaryColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total', 
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 22, 
                    color: AppTheme.secondaryColor,
                  )
                ),
                Text(
                  formatter.format(state.totalGeneral), 
                  style: const TextStyle(
                    color: AppTheme.primaryColor, 
                    fontWeight: FontWeight.w900, 
                    fontSize: 36,
                  )
                ),
              ],
            ),
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
        color: const Color(0xFFF0E7D8).withOpacity(0.5), // Light beige
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: child,
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dangerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(error, style: const TextStyle(color: AppTheme.dangerColor)),
    );
  }

  Widget _buildSuccess(BuildContext context, String orderId) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: AppTheme.successColor.withOpacity(0.1),
               shape: BoxShape.circle,
             ),
             child: const Icon(Icons.check_circle_rounded, color: AppTheme.successColor, size: 80),
           ),
           const SizedBox(height: 32),
           Text(
             '¡Inscripción Exitosa!', 
             style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.neutral900),
             textAlign: TextAlign.center
           ),
           const SizedBox(height: 16),
           Text(
             'Tu orden de venta ha sido generada correctamente en nuestro sistema administrativo.', 
             style: TextStyle(color: AppTheme.neutral600, height: 1.5),
             textAlign: TextAlign.center
           ),
           const SizedBox(height: 32),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
             decoration: BoxDecoration(
               color: AppTheme.neutral50,
               borderRadius: BorderRadius.circular(16),
               border: Border.all(color: AppTheme.neutral200),
             ),
             child: Column(
               children: [
                 const Text(
                   'ID DE ORDEN (NETSUITE)', 
                   style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.neutral500, letterSpacing: 1.2)
                 ),
                 const SizedBox(height: 4),
                 Text(
                   orderId, 
                   style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppTheme.primaryColor), 
                   textAlign: TextAlign.center
                 ),
               ],
             ),
           ),
           const SizedBox(height: 48),
           SizedBox(
             width: double.infinity,
             child: OutlinedButton(
               onPressed: () => Navigator.of(context).pop(),
               style: OutlinedButton.styleFrom(
                 padding: const EdgeInsets.all(18),
                 side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                 ),
               ),
               child: const Text(
                 'VOLVER AL INICIO', 
                 style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900)
               ),
             ),
           ),
        ],
      ),
    );
  }
}

