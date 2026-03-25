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

  void _addGuest(BuildContext modalContext) {
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
      Navigator.pop(modalContext);
    } else if (_selectedRelationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona el parentesco con el titular.'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
    }
  }

  void _showGuestModal() {
    _nameController.clear();
    _lastName1Controller.clear();
    _lastName2Controller.clear();
    _emailController.clear();
    _phoneController.clear();
    _selectedRelationship = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateModal) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Datos del Invitado',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppTheme.neutral900),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppTheme.neutral400, size: 24),
                              onPressed: () => Navigator.pop(modalContext),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nombre(s)*',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _lastName1Controller,
                          label: 'Apellido Paterno*',
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _lastName2Controller,
                          label: 'Apellido Materno',
                          icon: Icons.badge_outlined,
                          isRequired: false,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration('Correo Electrónico*', Icons.alternate_email_rounded),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration('Teléfono*', Icons.phone_outlined),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('Relación con el Titular*', Icons.people_outline_rounded),
                          value: _selectedRelationship,
                          items: _relationships
                              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                              .toList(),
                          onChanged: (v) => setStateModal(() => _selectedRelationship = v),
                          validator: (v) => v == null ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(modalContext),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.neutral500,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _addGuest(modalContext),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.neutral900,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(summerCourseProvider);
    final notifier = ref.read(summerCourseProvider.notifier);

    final guests = state.selectedParticipants.where((p) => p.isGuest).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invitados Especiales',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.neutral900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inscribe a amigos o familiares que no sean socios. Sus datos nos ayudarán a darles el mejor servicio.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral600,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 32),

          if (guests.isNotEmpty) ...[
            Text(
              'INVITADOS AÑADIDOS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppTheme.neutral500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            ...guests.map((participant) {
              final guest = participant.guest!;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(color: AppTheme.neutral200.withOpacity(0.6)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.vibrantGold.withOpacity(0.1),
                    child: const Icon(Icons.person_outline_rounded,
                        color: AppTheme.vibrantGold, size: 22),
                  ),
                  title: Text(
                    guest.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppTheme.neutral800, fontSize: 15),
                  ),
                  subtitle: Text(
                    '${guest.relationship} • ${guest.email}',
                    style:
                        const TextStyle(fontSize: 13, color: AppTheme.neutral500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppTheme.dangerColor, size: 20),
                    onPressed: () => notifier.removeParticipant(guest.email),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.dangerColor.withOpacity(0.05),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
          ],

          Center(
            child: OutlinedButton.icon(
              onPressed: _showGuestModal,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
              label: const Text('Añadir Invitado Extra', style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.neutral700,
                side: BorderSide(color: AppTheme.neutral300, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1, color: AppTheme.neutral200),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.neutral100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people_alt_rounded, color: AppTheme.neutral600, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.selectedParticipants.length} Participante${state.selectedParticipants.length != 1 ? 's' : ''} en Total',
                      style: const TextStyle(
                        color: AppTheme.neutral900,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${state.selectedParticipants.length - guests.length} familiar${(state.selectedParticipants.length - guests.length) != 1 ? 'es' : ''} directo${(state.selectedParticipants.length - guests.length) != 1 ? 's' : ''}  •  ${guests.length} invitado${guests.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: AppTheme.neutral500,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      textCapitalization: TextCapitalization.characters,
      validator: isRequired ? (v) => v!.isEmpty ? 'Requerido' : null : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.neutral500),
      prefixIcon: Icon(icon, color: AppTheme.neutral400, size: 20),
      filled: true,
      fillColor: AppTheme.neutral50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.neutral200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.neutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor),
      ),
    );
  }
}

