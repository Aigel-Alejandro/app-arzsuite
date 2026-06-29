import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';
import 'package:app_arzsuite/features/tournaments/models/tournament_model.dart';
import 'package:app_arzsuite/features/tournaments/providers/tournaments_provider.dart';
import 'package:app_arzsuite/features/profile/providers/profile_provider.dart';
import 'package:app_arzsuite/core/widgets/terms_conditions_view.dart';
import 'package:app_arzsuite/core/providers/terms_provider.dart';

class TournamentEnrollmentView extends ConsumerStatefulWidget {
  final TournamentModel tournament;
  const TournamentEnrollmentView({super.key, required this.tournament});

  @override
  ConsumerState<TournamentEnrollmentView> createState() => _TournamentEnrollmentViewState();
}

class _TournamentEnrollmentViewState extends ConsumerState<TournamentEnrollmentView> {
  String? _selectedBeneficiary;
  bool _termsAccepted = false;
  int? _selectedTeamId;
  bool _isEnrolling = false;
  bool _isCaptain = false;
  
  bool _isCreatingNewTeam = false;
  final TextEditingController _newTeamNameController = TextEditingController();

  TermsStatus? _termsStatus;

  @override
  void dispose() {
    _newTeamNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTerms();
    });
  }

  Future<void> _loadTerms() async {
    final status = await ref.read(termsProvider).checkTerms('torneos');
    if (mounted) {
      setState(() {
        _termsStatus = status;
        _termsAccepted = status.accepted || !status.required;
      });
    }
  }

  void _onTermsAccepted(bool accepted) {
    setState(() {
      _termsAccepted = accepted;
    });
  }

  void _showRoster(BuildContext context, List<TournamentParticipantModel> participants, String teamName, {String? capitanActual}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Roster Oficial', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.neutral500)),
                      const SizedBox(height: 4),
                      Text(teamName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppTheme.neutral100),
                Expanded(
                  child: ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final p = participants[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.neutral50)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                              child: const Icon(Icons.person, color: AppTheme.primaryColor, size: 18),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    p.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.neutral900),
                                  ),
                                  if (capitanActual != null && capitanActual.toLowerCase().trim() == p.nombre.toLowerCase().trim())
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.amber.shade600, borderRadius: BorderRadius.circular(4)),
                                      child: const Text('CAPITÁN DE EQUIPO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neutral100,
                        foregroundColor: AppTheme.neutral900,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openBeneficiarySelector(BuildContext context, List<Map<String, dynamic>> beneficiaries) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selecciona el Beneficiario', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppTheme.neutral100),
                  ...beneficiaries.map((b) {
                     int? age = b['age'];
                     bool isEnrolled = b['isEnrolled'] == true;
                     bool isAgeInvalid = b['isAgeInvalid'] == true;
                     bool isGenderInvalid = b['isGenderInvalid'] == true;
                     
                     bool isDisabled = isEnrolled || isAgeInvalid || isGenderInvalid;
                     
                     String subtitle = '';
                     if (isEnrolled) {
                       subtitle = 'Ya inscrito en este torneo';
                     } else if (isAgeInvalid) {
                       subtitle = 'No cumple con la edad requerida (${age ?? '?'} años)';
                     } else if (isGenderInvalid) {
                       subtitle = 'Género no permitido para esta categoría';
                     } else {
                       subtitle = age != null ? '$age años' : 'Edad sin proporcionar en perfil';
                     }
                     
                     return InkWell(
                       onTap: isDisabled ? null : () {
                         setState(() => _selectedBeneficiary = b['name']);
                         Navigator.pop(context);
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         color: isDisabled ? AppTheme.neutral50 : Colors.transparent,
                         child: Row(
                           children: [
                             CircleAvatar(
                               radius: 20,
                               backgroundColor: isDisabled ? AppTheme.neutral200 : AppTheme.primaryColor.withValues(alpha: 0.1),
                               child: Icon(isDisabled ? Icons.block : Icons.person, color: isDisabled ? AppTheme.neutral500 : AppTheme.primaryColor, size: 20),
                             ),
                             const SizedBox(width: 16),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     b['name'], 
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold, 
                                       fontSize: 15, 
                                       color: isDisabled ? AppTheme.neutral500 : AppTheme.neutral900,
                                       decoration: isEnrolled ? TextDecoration.lineThrough : null,
                                     )
                                   ),
                                   const SizedBox(height: 2),
                                   Text(
                                     subtitle, 
                                     style: TextStyle(
                                       color: isDisabled ? Colors.red.shade700 : AppTheme.neutral600, 
                                       fontSize: 13,
                                       fontWeight: isDisabled ? FontWeight.bold : FontWeight.normal,
                                     )
                                   ),
                                 ],
                               ),
                             ),
                             if (_selectedBeneficiary == b['name'] && !isDisabled)
                               const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                             else if (!isDisabled)
                               const Icon(Icons.chevron_right, color: AppTheme.neutral300),
                           ],
                         ),
                       ),
                     );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    
    List<Map<String, dynamic>> allBeneficiaries = [];
    if (profileAsync.value != null) {
      final String rawTitular = profileAsync.value!.fullname ?? '';
      final String cleanTitular = rawTitular.replaceFirst(RegExp(r'^\d+\s*'), '');
      
      allBeneficiaries.add({
        'id': profileAsync.value!.id,
        'name': "$cleanTitular (Titular)",
        'age': profileAsync.value!.age,
        'genero': profileAsync.value!.genero,
        'isEnrolled': false, // El titular siempre se muestra, incluso si ya está inscrito
      });
      for (var member in profileAsync.value!.associatedMembers) {
        if (member.fullname != null && member.fullname!.isNotEmpty) {
          final String cleanMember = member.fullname!.replaceFirst(RegExp(r'^\d+\s*'), '');
          final bool isMemberEnrolled = widget.tournament.sociosInscritos.contains(member.id.toString());
          allBeneficiaries.add({
            'id': member.id,
            'name': cleanMember,
            'age': member.age,
            'genero': member.genero,
            'isEnrolled': isMemberEnrolled,
          });
        }
      }
    }

    // No filtramos a los inscritos aquí para poder mostrarlos "tachados".
    List<Map<String, dynamic>> validBeneficiaries = List.from(allBeneficiaries);

    if (_selectedTeamId != null) {
      final selectedTeam = widget.tournament.equiposDisponibles.firstWhere((e) => e.id == _selectedTeamId);
      for (var i = 0; i < validBeneficiaries.length; i++) {
        var b = validBeneficiaries[i];
        int? age = b['age'];
        String? genero = b['genero'];
        
        b['isAgeInvalid'] = false;
        b['isGenderInvalid'] = false;
        
        if (age != null) {
          if (selectedTeam.edadMinima != null && age < selectedTeam.edadMinima!) b['isAgeInvalid'] = true;
          if (selectedTeam.edadMaxima != null && age > selectedTeam.edadMaxima!) b['isAgeInvalid'] = true;
        }

        if (genero != null && selectedTeam.generoPermitido != null && selectedTeam.generoPermitido != 'X') {
          if (selectedTeam.generoPermitido == 'F' && genero != 'F') b['isGenderInvalid'] = true;
          if (selectedTeam.generoPermitido == 'V' && genero != 'M') b['isGenderInvalid'] = true;
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Detalle del Torneo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingLarge),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.emoji_events, color: Colors.deepPurple, size: 32),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tournament.nombre,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.neutral900,
                              ),
                        ),
                        if (widget.tournament.descripcion != null && widget.tournament.descripcion!.isNotEmpty) ...[
                          const SizedBox(height: AppTheme.spacingSmall),
                          Text(
                            widget.tournament.descripcion!,
                            style: const TextStyle(color: AppTheme.neutral600),
                          ),
                        ],
                        const SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          "Formato: ${widget.tournament.formato?.toUpperCase() ?? 'COMPETICION'}",
                          style: const TextStyle(color: AppTheme.neutral800, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              Text(
                'Elige el Nivel o Equipo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutral900,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              
              if (widget.tournament.equiposDisponibles.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: AppTheme.neutral100,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: const Text('No hay niveles configurados aún.', style: TextStyle(color: AppTheme.neutral600)),
                )
              else
                Column(
                  children: widget.tournament.equiposDisponibles.map((equipo) {
                    final bool isSelected = _selectedTeamId == equipo.id;
                    final bool isFull = equipo.cupoMaximo != null && equipo.cupoActual >= equipo.cupoMaximo!;
                    final teamParticipants = widget.tournament.participantes.where((p) => p.equipoId == equipo.id).toList();

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: isFull ? AppTheme.neutral50 : (isSelected ? Colors.deepPurple.withValues(alpha: 0.03) : Colors.white),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                        border: Border.all(
                          color: isFull ? AppTheme.neutral200 : (isSelected ? Colors.deepPurple : AppTheme.neutral300),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
                      ),
                      child: InkWell(
                        onTap: isFull ? null : () {
                           setState(() {
                             _selectedTeamId = equipo.id;
                             _selectedBeneficiary = null; // Reiniciar si cambian de equipo
                           });
                        },
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            equipo.nombre,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: isFull ? AppTheme.neutral500 : (isSelected ? Colors.deepPurple : AppTheme.neutral900),
                                            )
                                          ),
                                        ),
                                        if (equipo.cupoMaximo != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: isFull ? Colors.red.withValues(alpha: 0.1) : Colors.deepPurple.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              isFull ? 'Cupo Lleno' : '${equipo.cupoActual}/${equipo.cupoMaximo} Inscritos',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isFull ? Colors.red.shade700 : Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (equipo.edadMinima != null || equipo.edadMaxima != null)
                                      Text(
                                        [
                                          if (equipo.edadMinima != null) 'Min: ${equipo.edadMinima} años',
                                          if (equipo.edadMaxima != null) 'Max: ${equipo.edadMaxima} años'
                                        ].join(' | '),
                                        style: TextStyle(color: isFull ? AppTheme.neutral400 : AppTheme.neutral500, fontSize: 12)
                                      ),
                                    if (teamParticipants.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: GestureDetector(
                                          onTap: () => _showRoster(context, teamParticipants, equipo.nombre, capitanActual: equipo.capitanActual),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.group, size: 14, color: Colors.deepPurple),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Ver inscritos (${teamParticipants.length})',
                                                style: const TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ]
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                isFull ? Icons.block : (isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
                                color: isFull ? AppTheme.neutral300 : (isSelected ? Colors.deepPurple : AppTheme.neutral400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList()
                    ..add(
                      Container(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                        decoration: BoxDecoration(
                          color: _isCreatingNewTeam ? Colors.deepPurple.withValues(alpha: 0.03) : Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                          border: Border.all(
                            color: _isCreatingNewTeam ? Colors.deepPurple : AppTheme.neutral300,
                            width: _isCreatingNewTeam ? 2 : 1,
                          ),
                          boxShadow: _isCreatingNewTeam ? [BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
                        ),
                        child: InkWell(
                          onTap: () {
                             setState(() {
                               _selectedTeamId = null;
                               _isCreatingNewTeam = true;
                               _selectedBeneficiary = null;
                             });
                          },
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '+ Crear Nuevo Equipo / Alias',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: _isCreatingNewTeam ? Colors.deepPurple : AppTheme.neutral900,
                                        )
                                      ),
                                    ),
                                    Icon(
                                      _isCreatingNewTeam ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                      color: _isCreatingNewTeam ? Colors.deepPurple : AppTheme.neutral400,
                                    ),
                                  ],
                                ),
                                if (_isCreatingNewTeam) ...[
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _newTeamNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Ej. Los invencibles',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: AppTheme.neutral300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: AppTheme.neutral300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: Colors.deepPurple),
                                      ),
                                    ),
                                    onChanged: (val) => setState((){}),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                ),

              const SizedBox(height: AppTheme.spacingLarge),

              Opacity(
                opacity: ((_selectedTeamId != null || _isCreatingNewTeam) && !_isEnrolling) ? 1.0 : 0.4,
                child: IgnorePointer(
                  ignoring: (_selectedTeamId == null && !_isCreatingNewTeam) || _isEnrolling,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beneficiario a Inscribir',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neutral900,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      InkWell(
                        onTap: () {
                          _openBeneficiarySelector(context, validBeneficiaries);
                        },
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppTheme.spacingMedium),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                            border: Border.all(color: AppTheme.neutral300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedBeneficiary ?? 'Toca para seleccionar familiar',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _selectedBeneficiary != null ? AppTheme.neutral900 : AppTheme.neutral500,
                                  fontWeight: _selectedBeneficiary != null ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.neutral500),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              
              if (_selectedBeneficiary != null && _selectedTeamId != null)
                Builder(
                  builder: (context) {
                    final selectedT = widget.tournament.equiposDisponibles.firstWhere((e) => e.id == _selectedTeamId);
                    final String? actualCaptain = selectedT.capitanActual;

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
                      padding: const EdgeInsets.all(AppTheme.spacingLarge),
                      decoration: BoxDecoration(
                        color: actualCaptain != null ? AppTheme.neutral100 : Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                        border: Border.all(color: actualCaptain != null ? AppTheme.neutral300 : Colors.amber.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            actualCaptain != null ? Icons.verified_user : Icons.star_rounded, 
                            color: actualCaptain != null ? AppTheme.neutral500 : Colors.amber, 
                            size: 28
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  actualCaptain != null ? 'Capitán Asignado' : 'Designarme como Capitán', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    color: actualCaptain != null ? AppTheme.neutral700 : AppTheme.neutral900
                                  )
                                ),
                                Text(
                                  actualCaptain != null 
                                    ? '$actualCaptain ya administra este equipo.'
                                    : 'Podrás subir marcadores de tu equipo.', 
                                  style: TextStyle(
                                    fontSize: 12, 
                                    color: actualCaptain != null ? AppTheme.neutral600 : AppTheme.neutral700
                                  )
                                ),
                              ],
                            ),
                          ),
                          if (actualCaptain == null)
                            Switch(
                              value: _isCaptain,
                              activeColor: Colors.amber,
                              onChanged: (val) {
                                setState(() => _isCaptain = val);
                              },
                            ),
                        ],
                      ),
                    );
                  }
                ),

              if (_termsStatus == null)
                const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
              else if (_termsStatus!.required)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                    border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _termsAccepted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        color: _termsAccepted ? AppTheme.successColor : Colors.deepPurple,
                      ),
                      const SizedBox(width: AppTheme.spacingMedium),
                      Expanded(
                        child: Text(
                          _termsAccepted ? 'Políticas del torneo aceptadas' : 'Debe revisar y aceptar los términos del torneo.',
                          style: TextStyle(
                            color: _termsAccepted ? AppTheme.successColor : AppTheme.neutral900,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (!_termsAccepted)
                        ElevatedButton(
                          onPressed: () {
                            if (_termsStatus?.terminos == null) return;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                                pageBuilder: (_, __, ___) => TermsConditionsView(
                                  title: 'Términos de Torneos',
                                  version: _termsStatus!.terminos!.version.toString(),
                                  content: _termsStatus!.terminos!.contenido,
                                  onAccept: () async {
                                    bool ok = await ref.read(termsProvider).acceptTerms('torneos', _termsStatus!.terminos!.version, _termsStatus!.terminos!.id);
                                    if (ok && mounted) {
                                      _onTermsAccepted(true);
                                      Navigator.pop(context);
                                    } else if (mounted) {
                                      ToastAlerts.showError(context, 'No se pudieron aceptar los términos');
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

              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_selectedBeneficiary != null && _termsAccepted && (_selectedTeamId != null || (_isCreatingNewTeam && _newTeamNameController.text.trim().isNotEmpty)) && !_isEnrolling)
                      ? () async {
                          setState(() => _isEnrolling = true);
                          try {
                              final String beneficiarySocioId = validBeneficiaries.firstWhere((b) => b['name'] == _selectedBeneficiary)['id'].toString();
                              final String finalName = _selectedBeneficiary!.replaceAll(' (Titular)', '');
                              
                              await ref.read(tournamentsProvider.notifier).inscribirTorneo(
                                widget.tournament.id, 
                                _isCreatingNewTeam ? null : _selectedTeamId, 
                                _isCreatingNewTeam ? _newTeamNameController.text.trim() : null,
                                finalName, 
                                beneficiarySocioId, 
                                _isCaptain
                              );
                            
                            if (mounted) {
                              ToastAlerts.showSuccess(context, 'Inscripción al torneo confirmada.');
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (mounted) {
                              String err = e.toString().replaceFirst('Exception: ', '');
                              ToastAlerts.showError(context, err);
                            }
                          } finally {
                            if (mounted) setState(() => _isEnrolling = false);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: _isEnrolling 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Inscribir', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              
              if (widget.tournament.partidos.isNotEmpty)
                ..._buildMatchesList(context),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMatchesList(BuildContext context) {
    return [
      const SizedBox(height: 32),
      Text(
        'Calendario de Juegos',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.neutral900,
            ),
      ),
      const SizedBox(height: 16),
      ...widget.tournament.partidos.map((match) {
        final localTeam = widget.tournament.equiposDisponibles.firstWhere(
          (e) => e.id == match.equipoLocalId,
          orElse: () => const TournamentTeamModel(id: -1, nombre: 'Desconocido', cupoActual: 0),
        );
        
        final localTeamName = localTeam.nombre;
        final visitTeamName = match.rivalNombre;
        
        // Verifica si yo (usuario actual) soy capitán de alguno
        final isLocalCap = localTeam.isUserCaptain;
        final isVisitCap = widget.tournament.equiposDisponibles.any((e) => e.nombre == visitTeamName && e.isUserCaptain);
        final isCaptainOfMatch = isLocalCap || isVisitCap;
        final isLocalContext = isLocalCap;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          color: AppTheme.neutral50,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: const Icon(Icons.sports_soccer, color: AppTheme.primaryColor),
            ),
            title: Text(
              "$localTeamName vs $visitTeamName",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(match.fecha ?? 'Fecha por definir', style: const TextStyle(fontSize: 12)),
                if (match.estado == 'finalizado' && match.golesLocal != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Resultado: ${match.golesLocal} - ${match.golesVisitante}',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green),
                    ),
                  )
                else if (match.estado == 'en_curso')
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Validación pendiente...',
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.amber),
                    ),
                  ),
              ],
            ),
            trailing: (isCaptainOfMatch && match.estado != 'finalizado') 
              ? IconButton(
                  icon: const Icon(Icons.score, color: AppTheme.primaryColor),
                  onPressed: () {
                    // Validar que no se pueda reportar marcador ANTES del torneo/partido
                    if (match.fecha != null) {
                      try {
                        final dateStr = match.fecha!.contains(':') 
                          ? (match.fecha!.split(':').length == 2 ? '${match.fecha}:00' : match.fecha!) 
                          : '${match.fecha} 00:00:00';
                        final matchDate = DateTime.parse(dateStr);
                        if (DateTime.now().isBefore(matchDate)) {
                          ToastAlerts.showWarning(context, 'Solo podrás reportar el marcador una vez que el partido inicie.');
                          return;
                        }
                      } catch (e) {
                         // Ignorar si hay un fallo de parsing y dejar pasar la acción por ahora
                      }
                    }
                    _openReportScoreModal(context, match, isLocalContext, localTeamName, visitTeamName);
                  },
                  tooltip: 'Reportar Marcador',
                )
              : const Icon(Icons.event_available, color: AppTheme.neutral400),
          ),
        );
      }),
    ];
  }

  void _openReportScoreModal(BuildContext context, TournamentMatchModel match, bool isLocal, String localTeam, String visitTeam) {
    int golesLocal = match.golesLocal ?? 0;
    int golesVisitante = match.golesVisitante ?? 0;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Reportar Marcador', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('Ingresa el resultado final. Si tu rival reporta el mismo marcador, este quedará aprobado oficialmente.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.neutral600)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(localTeam, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(onPressed: () => setModalState(() => golesLocal > 0 ? golesLocal-- : 0), icon: const Icon(Icons.remove_circle_outline)),
                                Text('$golesLocal', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                                IconButton(onPressed: () => setModalState(() => golesLocal++), icon: const Icon(Icons.add_circle_outline)),
                              ],
                            )
                          ],
                        ),
                        const Text('vs', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.neutral400, fontSize: 20)),
                        Column(
                          children: [
                            Text(visitTeam, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(onPressed: () => setModalState(() => golesVisitante > 0 ? golesVisitante-- : 0), icon: const Icon(Icons.remove_circle_outline)),
                                Text('$golesVisitante', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                                IconButton(onPressed: () => setModalState(() => golesVisitante++), icon: const Icon(Icons.add_circle_outline)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marcador propuesto oficialmente.')));
                          
                          // Consumimos el endpoint real de TorneosController->reportarMarcador()
                          final apiClient = ref.read(apiClientNotifierProvider);
                          await apiClient.dio.post('arzsuite/torneos/reportarMarcador', data: {
                            'partido_id': match.id,
                            'goles_local': golesLocal,
                            'goles_visitante': golesVisitante,
                            'es_local': isLocal,
                          });
                          
                          // Reload tournaments (to reflect status on current match)
                          ref.invalidate(tournamentsProvider);
                        },
                        child: const Text('Subir Marcador', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
