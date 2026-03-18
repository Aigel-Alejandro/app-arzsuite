import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirmación de Inscripción',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Revisa los datos antes de generar la orden:'),
          
          const SizedBox(height: 20),

          // Titular Summary
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
               leading: const Icon(Icons.person_pin, color: Colors.blue),
               title: Text(state.selectedTitular?.fullName ?? 'N/A'),
               subtitle: Text('Socio Titular • ID: ${state.selectedTitular?.membershipNumber}'),
            ),
          ),

          const SizedBox(height: 20),
          const Text('Participantes', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ...state.selectedParticipants.map((p) {
             return ListTile(
                dense: true,
                title: Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Semana(s): ${p.selectedWeekIds.map((id) => 'Semana $id').join(', ')}'),
                trailing: Text(formatter.format(p.totalCost), style: const TextStyle(fontWeight: FontWeight.bold)),
             );
          }),

          const Divider(height: 40),

          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                const Text('Total Final', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(formatter.format(state.totalGeneral), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 24)),
             ],
          ),

          const SizedBox(height: 40),

          if (state.errorMessage != null)
             Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => notifier.submitRegistration(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Confirmar y Generar Orden'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, String orderId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Icon(Icons.check_circle, color: Colors.green, size: 80),
             const SizedBox(height: 20),
             const Text('¡Orden Generada Exitosamente!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
             const SizedBox(height: 10),
             Text('Se ha creado la Orden de Venta en NetSuite con el ID:', textAlign: TextAlign.center),
             const SizedBox(height: 5),
             Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
             const SizedBox(height: 40),
             OutlinedButton(
               onPressed: () => Navigator.of(context).pop(),
               child: const Text('Regresar al Inicio'),
             ),
          ],
        ),
      ),
    );
  }
}
