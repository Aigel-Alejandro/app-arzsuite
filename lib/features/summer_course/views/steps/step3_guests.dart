import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/guest.dart';

class Step3Guests extends ConsumerStatefulWidget {
  const Step3Guests({super.key});

  @override
  ConsumerState<Step3Guests> createState() => _Step3GuestsState();
}

class _Step3GuestsState extends ConsumerState<Step3Guests> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastName1Controller = TextEditingController();
  final _lastName2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRelationship;

  final List<String> _relationships = ['Hijo(a)', 'Sobrino(a)', 'Nieto(a)', 'Amigo(a)', 'Otro'];

  bool _showForm = false;

  void _addGuest() {
    if (_formKey.currentState!.validate() && _selectedRelationship != null) {
      final state = ref.read(summerCourseProvider);
      final guest = Guest(
        firstName: _nameController.text,
        lastName: _lastName1Controller.text,
        secondLastName: _lastName2Controller.text,
        email: _emailController.text,
        phone: _phoneController.text,
        relationship: _selectedRelationship!,
        titularMembershipNumber: state.selectedTitular?.membershipNumber ?? 'N/A',
      );
      
      ref.read(summerCourseProvider.notifier).addGuest(guest);
      _resetForm();
    } else if (_selectedRelationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una relación')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _showForm = false;
      _nameController.clear();
      _lastName1Controller.clear();
      _lastName2Controller.clear();
      _emailController.clear();
      _phoneController.clear();
      _selectedRelationship = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);
    
    final guestsCount = state.selectedParticipants.where((p) => p.isGuest).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Invitados (Opcional)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('Agrega invitados que no son socios.'),
          
          const SizedBox(height: 20),

          if (guestsCount > 0)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.selectedParticipants.length,
              itemBuilder: (context, index) {
                final participant = state.selectedParticipants[index];
                if (!participant.isGuest) return const SizedBox.shrink();
                
                final guest = participant.guest!;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.person_add_alt),
                    title: Text(guest.fullName),
                    subtitle: Text('${guest.relationship} • ${guest.email}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => notifier.removeParticipant(guest.email),
                    ),
                  ),
                );
              },
            ),

          if (!_showForm)
            Center(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _showForm = true),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Invitado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  foregroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
              ),
            )
          else
            _buildGuestForm(),

          const SizedBox(height: 30),
          
          Text(
            'Participantes seleccionados en total: ${state.selectedParticipants.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre*'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastName1Controller,
              decoration: const InputDecoration(labelText: 'Apellido paterno*'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastName2Controller,
              decoration: const InputDecoration(labelText: 'Apellido materno'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico*'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono*'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Relación con el titular*'),
              items: _relationships.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => _selectedRelationship = v),
              validator: (v) => v == null ? 'Requerido' : null,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _showForm = false),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addGuest,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
