import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/features/activities/views/activity_terms_view.dart';
import 'package:app_arzsuite/core/widgets/terms_conditions_view.dart';
import 'package:app_arzsuite/core/widgets/toast_alerts.dart';
import 'package:app_arzsuite/features/activities/models/activity_model.dart';
import 'package:app_arzsuite/features/profile/providers/profile_provider.dart';
import 'package:app_arzsuite/features/activities/providers/mock_inscriptions_provider.dart';
import 'package:app_arzsuite/features/activities/providers/activities_provider.dart';
import 'package:app_arzsuite/core/providers/terms_provider.dart';

class ActivitySubscriptionView extends ConsumerStatefulWidget {
  final ActivityModel activity;
  const ActivitySubscriptionView({super.key, required this.activity});

  @override
  ConsumerState<ActivitySubscriptionView> createState() => _ActivitySubscriptionViewState();
}

class _ActivitySubscriptionViewState extends ConsumerState<ActivitySubscriptionView> {
  String? _selectedBeneficiary;
  bool _termsAccepted = false;
  int? _selectedGroupId;
  Set<String> _selectedItems = {};
  Set<int> _expandedDays = {};
  bool _isEnrolling = false;

  TermsStatus? _termsStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTerms();
    });
  }

  Future<void> _loadTerms() async {
    final status = await ref.read(termsProvider).checkTerms('actividades');
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

  String _diaToString(int dia) {
    const meta = {
      1: 'Lunes', 2: 'Martes', 3: 'Miércoles', 
      4: 'Jueves', 5: 'Viernes', 6: 'Sábado', 7: 'Domingo'
    };
    return meta[dia] ?? 'Día $dia';
  }

  String _shortDia(int dia) {
    const meta = {
      1: 'Lun', 2: 'Mar', 3: 'Mié', 
      4: 'Jue', 5: 'Vie', 6: 'Sáb', 7: 'Dom'
    };
    return meta[dia] ?? 'Día';
  }

  // Edad procesada en el backend

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.sports;
    switch (iconName) {
      case 'sports_soccer': return Icons.sports_soccer;
      case 'pool': return Icons.pool;
      case 'sports_tennis': return Icons.sports_tennis;
      case 'self_improvement': return Icons.self_improvement;
      default: return Icons.sports;
    }
  }

  Color _getColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return const Color(0xFF406EBA);
    String hexString = colorHex.replaceAll('#', '0xFF');
    if (hexString.length == 10) return Color(int.parse(hexString));
    return const Color(0xFF406EBA);
  }

  void _openBeneficiarySelector(BuildContext context, List<Map<String, dynamic>> beneficiaries, ActivityGroupModel selectedGroup) {
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
                        const SizedBox(height: 4),
                        Text('Grupo: ${selectedGroup.nombre}', style: const TextStyle(color: AppTheme.neutral600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppTheme.neutral100),
                  ...beneficiaries.where((b) {
                     int? age = b['age'];
                     // Lógica excluyente: 
                     // Validamos las edades permitidas del grupo versus la edad del familiar
                     if (selectedGroup.edadMin != null && selectedGroup.edadMax != null) {
                         if (age == null) return false; // El grupo exige limites, pero el usuario no tiene edad... rechazado
                         if (age < selectedGroup.edadMin! || age > selectedGroup.edadMax!) return false;
                     } else if (selectedGroup.edadMin != null) {
                         if (age == null) return false;
                         if (age < selectedGroup.edadMin!) return false;
                     } else if (selectedGroup.edadMax != null) {
                         if (age == null) return false;
                         if (age > selectedGroup.edadMax!) return false;
                     }

                     // Validación Doble Inscripción
                     bool canEnrollMultiple = widget.activity.tipo == 'arte' || widget.activity.tipo == 'otro';
                     if (!canEnrollMultiple) {
                         bool isEnrolled = ref.read(mockInscriptionsProvider).contains('${b['name']}-${widget.activity.id}');
                         if (isEnrolled) return false;
                     }

                     // Si el grupo no tiene límites de edad, TODOS pasan. Si sí los tiene y el miembro cumple, pasa.
                     return true;
                  }).map((b) {
                     int? age = b['age'];
                     
                     return InkWell(
                       onTap: () {
                         setState(() => _selectedBeneficiary = b['name']);
                         Navigator.pop(context);
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         color: Colors.transparent,
                         child: Row(
                           children: [
                             CircleAvatar(
                               radius: 20,
                               backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                               child: const Icon(Icons.person, color: AppTheme.primaryColor, size: 20),
                             ),
                             const SizedBox(width: 16),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(b['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.neutral900)),
                                   const SizedBox(height: 2),
                                   Text(age != null ? '$age años' : 'Edad sin proporcionar en perfil', style: const TextStyle(color: AppTheme.neutral600, fontSize: 13)),
                                 ],
                               ),
                             ),
                             if (_selectedBeneficiary == b['name'])
                               const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                             else
                               const Icon(Icons.chevron_right, color: AppTheme.neutral300),
                           ],
                         ),
                       ),
                     );
                  }),
                  if (beneficiaries.where((b) {
                     int? age = b['age'];
                     if (selectedGroup.edadMin != null && selectedGroup.edadMax != null) {
                         if (age == null) return false;
                         if (age < selectedGroup.edadMin! || age > selectedGroup.edadMax!) return false;
                     } else if (selectedGroup.edadMin != null) {
                         if (age == null) return false;
                         if (age < selectedGroup.edadMin!) return false;
                     } else if (selectedGroup.edadMax != null) {
                         if (age == null) return false;
                         if (age > selectedGroup.edadMax!) return false;
                     }
                     bool canEnrollMultiple = widget.activity.tipo == 'arte' || widget.activity.tipo == 'otro';
                     if (!canEnrollMultiple) {
                         bool isEnrolled = ref.read(mockInscriptionsProvider).contains('${b['name']}-${widget.activity.id}');
                         if (isEnrolled) return false;
                     }
                     return true;
                  }).isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text('Ningún miembro cumple con la edad o ya están inscritos.', style: TextStyle(color: AppTheme.dangerColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
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
    
    // Preparar lista rica de integrantes familiares
    List<Map<String, dynamic>> validBeneficiaries = [];
    if (profileAsync.value != null) {
      final String rawTitular = profileAsync.value!.fullname ?? '';
      final String cleanTitular = rawTitular.replaceFirst(RegExp(r'^\d+\s*'), '');
      
      validBeneficiaries.add({
        'id': profileAsync.value!.id,
        'name': "$cleanTitular (Titular)",
        'age': profileAsync.value!.age,
      });
      for (var member in profileAsync.value!.associatedMembers) {
        if (member.fullname != null && member.fullname!.isNotEmpty) {
          final String cleanMember = member.fullname!.replaceFirst(RegExp(r'^\d+\s*'), '');
          validBeneficiaries.add({
            'id': member.id,
            'name': cleanMember,
            'age': member.age,
          });
        }
      }
    }

    ActivityGroupModel? currentSelectedGroup;
    if (_selectedGroupId != null) {
      try {
        currentSelectedGroup = widget.activity.grupos.firstWhere((g) => g.id == _selectedGroupId);
      } catch (_) {}
    }

    // Hemos retirado MainLayout para que el botón inferior no sufra overlays
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getColor(widget.activity.color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_getIconData(widget.activity.icono), color: _getColor(widget.activity.color), size: 32),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.activity.nombre,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.neutral900,
                              ),
                        ),
                        if (widget.activity.descripcion != null) ...[
                          const SizedBox(height: AppTheme.spacingSmall),
                          Text(
                            widget.activity.descripcion!,
                            style: const TextStyle(color: AppTheme.neutral600),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              Text(
                'Elige un Grupo y Horario',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutral900,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              
              if (widget.activity.grupos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: AppTheme.neutral100,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: const Text('No hay horarios ni grupos configurados aún.', style: TextStyle(color: AppTheme.neutral600)),
                )
              else
                Column(
                  children: widget.activity.grupos.map((grupo) {
                    final bool isUnlimited = !grupo.tieneCupo;
                    final bool isFull = !isUnlimited && (grupo.cupoDisponible ?? 0) <= 0;
                    final bool isSelected = _selectedGroupId == grupo.id;

                    String ageText = "Libre (Cualquier Edad)";
                    if (grupo.edadMin != null && grupo.edadMax != null) {
                       ageText = "De ${grupo.edadMin} a ${grupo.edadMax} años";
                    } else if (grupo.edadMin != null) {
                       ageText = "Mayores de ${grupo.edadMin} años";
                    } else if (grupo.edadMax != null) {
                       ageText = "Menores de ${grupo.edadMax} años";
                    }

                    String spotsText = isUnlimited ? "Ilimitado" : (isFull ? "Agotado" : "${grupo.cupoDisponible} lugares");

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.03) : Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.neutral300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: isSelected || widget.activity.grupos.length == 1,
                          onExpansionChanged: (expanded) {
                            if (expanded && !isFull) {
                              setState(() {
                                if (_selectedGroupId != grupo.id) {
                                  _selectedGroupId = grupo.id;
                                  _selectedItems.clear();
                                  _expandedDays.clear();
                                }
                              });
                            }
                          },
                          title: Text(
                            grupo.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isFull ? AppTheme.neutral500 : AppTheme.neutral900,
                            )
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$ageText • Cupo: $spotsText',
                                style: TextStyle(
                                  color: isFull ? AppTheme.dangerColor : AppTheme.neutral600, 
                                  fontSize: 13,
                                  fontWeight: isFull ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                              if (grupo.equipos.expand((e) => e.horarios).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    grupo.equipos.expand((e) => e.horarios).map((h) => '${_shortDia(h.diaSemana)} ${h.horaInicio.substring(0, 5)}').toSet().join(', '),
                                    style: TextStyle(
                                      color: isFull ? AppTheme.neutral400 : AppTheme.primaryColor.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: grupo.equipos.isEmpty 
                            ? [const Text('Horarios por confirmar', style: TextStyle(color: AppTheme.neutral500, fontStyle: FontStyle.italic))]
                            : widget.activity.tipo == 'deporte_equipo' 
                              ? _buildEquipoLevelRadios(grupo, isFull) // Torneos o deportes en bloque
                              : _buildHorarioLevelRadios(grupo, isFull), // Clases o talleres específicos
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: AppTheme.spacingLarge),

              // --- Selector de Expediente Familiar (Ahora por BotoomSheet Dinámico) ---
              Opacity(
                opacity: (_selectedItems.isNotEmpty && !_isEnrolling) ? 1.0 : 0.4,
                child: IgnorePointer(
                  ignoring: _selectedItems.isEmpty || _isEnrolling,
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
                          if (currentSelectedGroup != null) {
                            _openBeneficiarySelector(context, validBeneficiaries, currentSelectedGroup!);
                          }
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
                                _selectedBeneficiary ?? 'Toca para seleccionar familiar validado',
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

              // --- Términos y Condiciones ---
              if (_termsStatus == null)
                const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
              else if (_termsStatus!.required)
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
                          _termsAccepted ? 'Políticas aceptadas para la inscripción' : 'Debe revisar y aceptar los términos de la actividad.',
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
                                  title: 'Términos de Actividades',
                                  version: _termsStatus!.terminos!.version.toString(),
                                  content: _termsStatus!.terminos!.contenido,
                                  onAccept: () async {
                                    bool ok = await ref.read(termsProvider).acceptTerms('actividades', _termsStatus!.terminos!.version, _termsStatus!.terminos!.id);
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
                  onPressed: (_selectedBeneficiary != null && _termsAccepted && _selectedItems.isNotEmpty && !_isEnrolling)
                      ? () async {
                          setState(() => _isEnrolling = true);
                          try {
                            for (var item in _selectedItems) {
                              final parts = item.split('-');
                              final eqId = int.parse(parts[0]);
                              final horId = parts[1] == 'null' ? null : int.parse(parts[1]);
                              
                              final String beneficiarySocioId = validBeneficiaries.firstWhere((b) => b['name'] == _selectedBeneficiary)['id'].toString();
                              final String finalName = _selectedBeneficiary!.replaceAll(' (Titular)', '');
                              await ref.read(activitiesProvider.notifier).inscribirActividad(eqId, horId, finalName, beneficiarySocioId);
                              ref.read(mockInscriptionsProvider.notifier).addInscription(_selectedBeneficiary!, widget.activity.id);
                            }
                            
                            if (mounted) {
                              ToastAlerts.showSuccess(context, 'Inscripción confirmada para $_selectedBeneficiary de forma exitosa.');
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
              
              // Evita que el botón quede pegado al final de la pantalla
              SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to render list tiles based on Activity Type
  List<Widget> _buildEquipoLevelRadios(ActivityGroupModel grupo, bool isFull) {
    return grupo.equipos.map((equipo) {
      final key = "${equipo.id}-null";
      final isChecked = _selectedItems.contains(key);
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: InkWell(
          onTap: isFull ? null : () {
            setState(() {
              if (_selectedGroupId != grupo.id) {
                _selectedGroupId = grupo.id;
                _selectedItems.clear();
                _expandedDays.clear();
              }
              if (isChecked) {
                _selectedItems.remove(key);
              } else {
                _selectedItems.add(key);
              }
              _selectedBeneficiary = null;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isChecked 
                  ? AppTheme.primaryColor.withValues(alpha: 0.08) 
                  : (isFull ? AppTheme.neutral100 : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isChecked 
                    ? AppTheme.primaryColor 
                    : (isFull ? AppTheme.neutral200 : AppTheme.neutral300),
                width: isChecked ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(equipo.nombre, style: TextStyle(fontWeight: FontWeight.w900, color: isFull ? AppTheme.neutral500 : (isChecked ? AppTheme.primaryColor : AppTheme.neutral900), fontSize: 14)),
                      if (equipo.horarios.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('Modalidad de Torneo / Equipo completo', style: TextStyle(fontSize: 13, color: isFull ? AppTheme.neutral500 : AppTheme.neutral600, fontStyle: FontStyle.italic)),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: equipo.horarios.map((horario) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time_filled_rounded, size: 14, color: isFull ? AppTheme.neutral400 : AppTheme.neutral600),
                                  const SizedBox(width: 8),
                                  Text('${_diaToString(horario.diaSemana)} de ${horario.horaInicio.substring(0, 5)} a ${horario.horaFin.substring(0, 5)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isFull ? AppTheme.neutral500 : AppTheme.neutral700)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, 
                  size: 24, 
                  color: isChecked 
                      ? AppTheme.primaryColor 
                      : (isFull ? AppTheme.neutral300 : AppTheme.neutral400)
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildHorarioLevelRadios(ActivityGroupModel grupo, bool isFull) {
    // Agrupar los horarios por día de la semana
    Map<int, List<Map<String, dynamic>>> schedulesByDay = {};
    List<Widget> fallbackChildren = [];

    for (var equipo in grupo.equipos) {
      if (equipo.horarios.isEmpty) {
        continue; // No presentamos "equipos" vacíos (sin horarios) en actividades individuales
      }

      for (var horario in equipo.horarios) {
        int day = horario.diaSemana;
        schedulesByDay.putIfAbsent(day, () => []);
        schedulesByDay[day]!.add({
          'equipo_id': equipo.id,
          'horario_id': horario.id,
          'hora_inicio': horario.horaInicio,
          'hora_fin': horario.horaFin,
          'tiene_cupo': horario.tieneCupo,
          'cupo_disponible': horario.cupoDisponible,
        });
      }
    }

    if (schedulesByDay.isEmpty) {
      return fallbackChildren;
    }

    final sortedDays = schedulesByDay.keys.toList()..sort();
    
    // Fila superior de días estructurada como un calendario accesible
    Widget calendarRow = LayoutBuilder(
      builder: (context, constraints) {
        // Cálculo para que quepan 4 cuadrados íntegros y el quinto se asome (cue de scroll),
        // usando el espacio interior libre disponible en el contenedor.
        double itemWidth = (constraints.maxWidth - (12.0 * 4)) / 4.5;
        // Limitar para que en pantallas extrañas no se deforme drásticamente.
        itemWidth = itemWidth.clamp(60.0, 76.0);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: sortedDays.map((day) {
              final isDaySelected = _expandedDays.contains(day);
              
              return GestureDetector(
                onTap: isFull ? null : () {
                  setState(() {
                    if (isDaySelected) {
                      _expandedDays.remove(day);
                      _selectedItems.removeWhere((item) {
                        final parts = item.split('-');
                        if (parts.length != 2) return false;
                        int eqId = int.parse(parts[0]);
                        int? hId = parts[1] == 'null' ? null : int.parse(parts[1]);
                        return schedulesByDay[day]!.any((s) => s['equipo_id'] == eqId && s['horario_id'] == hId);
                      });
                    } else {
                      _expandedDays.add(day);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12.0, top: 4, bottom: 4),
                  width: itemWidth,
                  height: itemWidth,
                  decoration: BoxDecoration(
                    color: isDaySelected ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDaySelected ? AppTheme.primaryColor : AppTheme.neutral300,
                  width: isDaySelected ? 2 : 1,
                ),
                boxShadow: isDaySelected 
                  ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))]
                  : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _shortDia(day).toUpperCase(),
                    style: TextStyle(
                      color: isDaySelected ? Colors.white : AppTheme.neutral800,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (isDaySelected)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  },
);

    List<Widget> children = [...fallbackChildren, calendarRow, const SizedBox(height: 12)];

    if (_expandedDays.isEmpty) {
      children.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Toca uno o más días arriba para ver y seleccionar sus horarios disponibles.',
            style: TextStyle(color: AppTheme.neutral500, fontStyle: FontStyle.italic, fontSize: 13),
          ),
        ),
      );
    }

    for (var day in sortedDays) {
      if (!_expandedDays.contains(day)) continue; // Solo mostramos si el día está seleccionado
      
      schedulesByDay[day]!.sort((a, b) => (a['hora_inicio'] as String).compareTo(b['hora_inicio'] as String));
      
      List<Widget> chips = schedulesByDay[day]!.map((sched) {
        final key = "${sched['equipo_id']}-${sched['horario_id']}";
        final isChecked = _selectedItems.contains(key);
        final timeStr = "${(sched['hora_inicio'] as String).substring(0, 5)} - ${(sched['hora_fin'] as String).substring(0, 5)} hrs";

        final bool tieneCupo = sched['tiene_cupo'] as bool? ?? false;
        final int? cupoDisp = sched['cupo_disponible'] as int?;
        final bool isHorarioFull = tieneCupo && cupoDisp != null && cupoDisp <= 0;
        final bool isDisabled = isFull || isHorarioFull;

        return InkWell(
          onTap: isDisabled ? null : () {
            setState(() {
              if (_selectedGroupId != grupo.id) {
                _selectedGroupId = grupo.id;
                _selectedItems.clear();
                _expandedDays.clear();
              }
              if (isChecked) {
                _selectedItems.remove(key);
              } else {
                // Opcional: Para permitir solo un horario por día, removemos el anterior (Radio Button per day)
                _selectedItems.removeWhere((item) {
                  final parts = item.split('-');
                  if (parts.length != 2) return false;
                  int eqId = int.parse(parts[0]);
                  int? hId = parts[1] == 'null' ? null : int.parse(parts[1]);
                  return schedulesByDay[day]!.any((s) => s['equipo_id'] == eqId && s['horario_id'] == hId);
                });
                
                _selectedItems.add(key);
              }
              _selectedBeneficiary = null;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: isChecked 
                  ? AppTheme.primaryColor.withValues(alpha: 0.08) 
                  : (isDisabled ? AppTheme.neutral100 : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isChecked 
                    ? AppTheme.primaryColor 
                    : (isDisabled ? AppTheme.neutral200 : AppTheme.neutral300),
                width: isChecked ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, 
                  size: 18, 
                  color: isChecked 
                      ? AppTheme.primaryColor 
                      : (isDisabled ? AppTheme.neutral300 : AppTheme.neutral400)
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: isChecked 
                              ? AppTheme.primaryColor 
                              : (isDisabled ? AppTheme.neutral400 : AppTheme.neutral900),
                          fontWeight: isChecked ? FontWeight.w900 : FontWeight.w600,
                          fontSize: 13,
                          decoration: isHorarioFull ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (tieneCupo && cupoDisp != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            isHorarioFull ? 'Agotado' : 'Quedan $cupoDisp lugares',
                            style: TextStyle(
                              color: isHorarioFull 
                                  ? AppTheme.dangerColor 
                                  : (cupoDisp <= 3 ? Colors.orange : AppTheme.secondaryColor),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();

      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _diaToString(day).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.neutral900, fontSize: 13, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 10) / 2;
                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: chips.map((c) => SizedBox(width: itemWidth, child: c)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return children;
  }
}
