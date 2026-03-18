import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
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

  final List<String> _relationships = [
    'Hijo(a)',
    'Sobrino(a)',
    'Nieto(a)',
    'Amigo(a)',
    'Otro'
  ];

  bool _showForm = false;

  void _addGuest() {
    if (_formKey.currentState!.validate() && _selectedRelationship != null) {
      final state = ref.read(summerCourseProvider);
      final guest = Guest(
        firstName: _nameController.text.toUpperCase(),
        lastName: _lastName1Controller.text.toUpperCase(),
        secondLastName: _lastName2Controller.text.toUpperCase(),
        email: _emailController.text,
        phone: _phoneController.text,
        relationship: _selectedRelationship!,
        titularMembershipNumber:
            state.selectedTitular?.membershipNumber ?? 'N/A',
      );

      ref.read(summerCourseProvider.notifier).addGuest(guest);
      _resetForm();
    } else if (_selectedRelationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona el parentesco con el titular.'),
          backgroundColor: AppTheme.dangerColor,
        ),
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

    final guests = state.selectedParticipants.where((p) => p.isGuest).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invitados Especiales',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Puedes inscribir a personas que no sean socios del club. Agrega sus datos aquí:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                ),
          ),
          const SizedBox(height: 24),

          if (guests.isNotEmpty) ...[
            Text(
              'INVITADOS AÑADIDOS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutral500,
                    letterSpacing: 1.1,
                  ),
            ),
            const SizedBox(height: 16),
            ...guests.map((participant) {
              final guest = participant.guest!;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.vibrantGold.withOpacity(0.1),
                    child: const Icon(Icons.person_add_rounded,
                        color: AppTheme.vibrantGold, size: 20),
                  ),
                  title: Text(
                    guest.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppTheme.neutral900),
                  ),
                  subtitle: Text(
                    '${guest.relationship} • ${guest.email}',
                    style:
                        const TextStyle(fontSize: 12, color: AppTheme.neutral500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppTheme.dangerColor),
                    onPressed: () => notifier.removeParticipant(guest.email),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
          ],

          if (!_showForm)
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.neutral100.withOpacity(0.5),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusGlobal),
                border: Border.all(
                  color: AppTheme.neutral200,
                  style: BorderStyle.solid,
                ),
              ),
              child: InkWell(
                onTap: () => setState(() => _showForm = true),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusGlobal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline_rounded,
                        color: AppTheme.primaryColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Añadir Invitado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            _buildGuestForm(),

          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.group_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen de Participantes',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${state.selectedParticipants.length} en total (${guests.length} invitados)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestForm() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos del Invitado',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre(s)*',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastName1Controller,
              decoration: const InputDecoration(
                labelText: 'Apellido Paterno*',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastName2Controller,
              decoration: const InputDecoration(
                labelText: 'Apellido Materno',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico*',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono*',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Relación con el Titular*',
                prefixIcon: Icon(Icons.people_outline_rounded),
              ),
              items: _relationships
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedRelationship = v),
              validator: (v) => v == null ? 'Requerido' : null,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => _showForm = false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addGuest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.vibrantGold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Añadir Invitado'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

