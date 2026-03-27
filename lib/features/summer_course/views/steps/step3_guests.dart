import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/summer_course/providers/summer_course_provider.dart';
import 'package:app_arzsuite/features/summer_course/models/guest.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';

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
  final _rfcController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;
  String? _selectedRelationship;

  final List<String> _relationships = [
    'Hijo(a)',
    'Sobrino(a)',
    'Nieto(a)',
    'Amigo(a)',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_generateRfc);
    _lastName1Controller.addListener(_generateRfc);
    _lastName2Controller.addListener(_generateRfc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastName1Controller.dispose();
    _lastName2Controller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _rfcController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  String _cleanRfcString(String input) {
    return input.toUpperCase().replaceAll(RegExp(r'[^A-ZÑ]'), '');
  }

  void _generateRfc() {
    if (_nameController.text.isEmpty || _lastName1Controller.text.isEmpty || _selectedBirthDate == null) {
      _rfcController.text = ''; // Esperar a tener datos clave
      return;
    }

    final name = _cleanRfcString(_nameController.text);
    final last1 = _cleanRfcString(_lastName1Controller.text);
    final last2 = _cleanRfcString(_lastName2Controller.text);

    if (last1.isEmpty || name.isEmpty) return;

    String firstVowel = 'X';
    for (int i = 1; i < last1.length; i++) {
      if (['A', 'E', 'I', 'O', 'U'].contains(last1[i])) {
        firstVowel = last1[i];
        break;
      }
    }

    final String p1 = last1.length > 1 ? '${last1[0]}$firstVowel' : '${last1[0]}X';
    final String p2 = last2.isNotEmpty ? last2[0] : 'X';
    
    var nameParts = _nameController.text.toUpperCase().split(' ');
    String selectedName = nameParts.first;
    if (nameParts.length > 1 && (selectedName == 'MARIA' || selectedName == 'JOSE')) {
      selectedName = nameParts[1];
    }
    final String p3 = selectedName.isNotEmpty ? _cleanRfcString(selectedName)[0] : 'X';

    final String yy = _selectedBirthDate!.year.toString().substring(2);
    final String mm = _selectedBirthDate!.month.toString().padLeft(2, '0');
    final String dd = _selectedBirthDate!.day.toString().padLeft(2, '0');

    _rfcController.text = '$p1$p2$p3$yy$mm$dd';
  }

  void _addGuest(BuildContext modalContext, [String? originalEmail]) {
    if (_formKey.currentState!.validate() && _selectedRelationship != null) {
      final state = ref.read(summerCourseProvider);
      final guest = Guest(
        firstName: _nameController.text.toUpperCase(),
        lastName: _lastName1Controller.text.toUpperCase(),
        secondLastName: _lastName2Controller.text.toUpperCase(),
        email: _emailController.text,
        phone: _phoneController.text,
        birthDate: _selectedBirthDate != null ? '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}' : null,
        relationship: _selectedRelationship!,
        titularMembershipNumber:
            state.selectedTitular?.membershipNumber ?? 'N/A',
        rfc: _rfcController.text,
      );

      if (originalEmail != null) {
        ref.read(summerCourseProvider.notifier).removeParticipant(originalEmail);
      }
      ref.read(summerCourseProvider.notifier).addGuest(guest);
      Navigator.pop(modalContext);
    } else if (_selectedRelationship == null) {
      ToastAlerts.showWarning(context, 'Por favor selecciona el parentesco con el titular.');
    }
  }

  void _showGuestModal([Guest? guestToEdit]) {
    if (guestToEdit != null) {
      _nameController.text = guestToEdit.firstName;
      _lastName1Controller.text = guestToEdit.lastName;
      _lastName2Controller.text = guestToEdit.secondLastName ?? '';
      _emailController.text = guestToEdit.email;
      _phoneController.text = guestToEdit.phone;
      if (guestToEdit.birthDate != null && guestToEdit.birthDate!.isNotEmpty) {
        _selectedBirthDate = DateTime.tryParse(guestToEdit.birthDate!);
        if (_selectedBirthDate != null) {
          _birthDateController.text = '${_selectedBirthDate!.day.toString().padLeft(2, '0')}/${_selectedBirthDate!.month.toString().padLeft(2, '0')}/${_selectedBirthDate!.year}';
        }
      }
      _selectedRelationship = _relationships.contains(guestToEdit.relationship) 
          ? guestToEdit.relationship 
          : 'Otro';
    } else {
      _nameController.clear();
      _lastName1Controller.clear();
      _lastName2Controller.clear();
      _emailController.clear();
      _phoneController.clear();
      _birthDateController.clear();
      _selectedBirthDate = null;
      _selectedRelationship = null;
      _rfcController.clear();
    }

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
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                            Text(
                              guestToEdit != null ? 'Editar Invitado' : 'Datos del Invitado',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            IconButton(
                              icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), size: 24),
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
                          controller: _birthDateController,
                          decoration: _inputDecoration(context, 'Fecha de Nacimiento*', Icons.calendar_today_rounded),
                          readOnly: true,
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 5)),
                              firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                              lastDate: DateTime.now(),
                              locale: const Locale('es', 'MX'),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                      primary: AppTheme.primaryColor,
                                      onPrimary: Colors.white,
                                      surface: Theme.of(context).colorScheme.surface,
                                      onSurface: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && picked != _selectedBirthDate) {
                              setStateModal(() {
                                _selectedBirthDate = picked;
                                _birthDateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                _generateRfc(); // Disparar cálculo
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration(context, 'Correo Electrónico*', Icons.alternate_email_rounded),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration(context, 'Teléfono*', Icons.phone_outlined),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _rfcController,
                          decoration: _inputDecoration(context, 'RFC (Auto-generado)', Icons.badge_rounded).copyWith(
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          ),
                          readOnly: true,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration(context, 'Relación con el Titular*', Icons.people_outline_rounded),
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
                                  foregroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _addGuest(modalContext, guestToEdit?.email),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.neutral100 : AppTheme.neutral900;
    final subTextColor = isDark ? AppTheme.neutral400 : AppTheme.neutral500;
    final borderColor = isDark ? AppTheme.neutral700 : AppTheme.neutral200;

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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inscribe a amigos o familiares que no sean socios. Sus datos nos ayudarán a darles el mejor servicio.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
                color: subTextColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            ...guests.map((participant) {
              final guest = participant.guest!;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(color: Theme.of(context).dividerColor),
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
                  ),
                  subtitle: Text(
                    '${guest.relationship} • ${guest.email}',
                    style:
                        TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: subTextColor),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).colorScheme.surface,
                    onSelected: (action) {
                      if (action == 'edit') {
                        _showGuestModal(guest);
                      } else if (action == 'delete') {
                        notifier.removeParticipant(guest.email);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_rounded, color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 12),
                            Text('Editar', style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline_rounded, color: AppTheme.dangerColor, size: 20),
                            const SizedBox(width: 12),
                            const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.dangerColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showGuestModal(guest),
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
                foregroundColor: isDark ? AppTheme.neutral200 : AppTheme.neutral700,
                side: BorderSide(color: isDark ? AppTheme.neutral600 : AppTheme.neutral300, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.people_alt_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.selectedParticipants.length} Participante${state.selectedParticipants.length != 1 ? 's' : ''} en Total',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${state.selectedParticipants.length - guests.length} familiar${(state.selectedParticipants.length - guests.length) != 1 ? 'es' : ''} directo${(state.selectedParticipants.length - guests.length) != 1 ? 's' : ''}  •  ${guests.length} invitado${guests.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
      decoration: _inputDecoration(context, label, icon),
      textCapitalization: TextCapitalization.characters,
      validator: isRequired ? (v) => v!.isEmpty ? 'Requerido' : null : null,
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
    );
  }
}

