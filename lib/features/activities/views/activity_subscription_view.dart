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
import 'package:app_arzsuite/features/activities/views/mis_reservas_view.dart';
import 'package:app_arzsuite/features/activities/views/activities_dashboard_view.dart';

class ActivitySubscriptionView extends ConsumerStatefulWidget {
  final ActivityModel activity;
  const ActivitySubscriptionView({super.key, required this.activity});

  @override
  ConsumerState<ActivitySubscriptionView> createState() =>
      _ActivitySubscriptionViewState();
}

class _ActivitySubscriptionViewState
    extends ConsumerState<ActivitySubscriptionView> {
  Set<String> _selectedBeneficiaries = {};
  Set<String> _selectedLugares = {};
  bool _termsAccepted = false;
  int? _selectedGroupId;
  Set<String> _selectedItems = {};
  Map<int, int> _activeDayFilters = {};
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
      1: 'Lunes',
      2: 'Martes',
      3: 'Miércoles',
      4: 'Jueves',
      5: 'Viernes',
      6: 'Sábado',
      7: 'Domingo',
    };
    return meta[dia] ?? 'Día $dia';
  }

  String _shortDia(int dia) {
    const meta = {
      1: 'Lun',
      2: 'Mar',
      3: 'Mié',
      4: 'Jue',
      5: 'Vie',
      6: 'Sáb',
      7: 'Dom',
    };
    return meta[dia] ?? 'Día';
  }

  // Edad procesada en el backend

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.sports;
    switch (iconName) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'pool':
        return Icons.pool;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'self_improvement':
        return Icons.self_improvement;
      default:
        return Icons.sports;
    }
  }

  Color _getColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return const Color(0xFF406EBA);
    String hexString = colorHex.replaceAll('#', '0xFF');
    if (hexString.length == 10) return Color(int.parse(hexString));
    return const Color(0xFF406EBA);
  }

  void _openBeneficiarySelector(
    BuildContext context,
    List<Map<String, dynamic>> beneficiaries,
    ActivityGroupModel selectedGroup,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
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
                        Text(
                          'Selecciona el Beneficiario',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Grupo: ${selectedGroup.nombre}',
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  ...beneficiaries
                      .where((b) {
                        int? age = b['age'];
                        // Lógica excluyente:
                        // Validamos las edades permitidas del grupo versus la edad del familiar
                        if (selectedGroup.edadMin != null &&
                            selectedGroup.edadMax != null) {
                          if (age == null)
                            return false; // El grupo exige limites, pero el usuario no tiene edad... rechazado
                          if (age < selectedGroup.edadMin! ||
                              age > selectedGroup.edadMax!)
                            return false;
                        } else if (selectedGroup.edadMin != null) {
                          if (age == null) return false;
                          if (age < selectedGroup.edadMin!) return false;
                        } else if (selectedGroup.edadMax != null) {
                          if (age == null) return false;
                          if (age > selectedGroup.edadMax!) return false;
                        }

                        // Validación Doble Inscripción (real)
                        int? benefEntityId = b['entityid'] as int?;
                        if (benefEntityId != null && benefEntityId != 0) {
                          bool isEnrolledInSelected = false;

                          for (final item in _selectedItems) {
                            final parts = item.split('-');
                            final eqId = int.tryParse(parts[0]);
                            final horId = parts.length > 1 && parts[1] != 'null' ? int.tryParse(parts[1]) : null;

                            for (final eq in selectedGroup.equipos) {
                              if (eq.id == eqId) {
                                if (horId != null) {
                                  for (final h in eq.horarios) {
                                    if (h.id == horId && h.alumnosInscritos.contains(benefEntityId)) {
                                      isEnrolledInSelected = true;
                                      break;
                                    }
                                  }
                                } else {
                                  for (final h in eq.horarios) {
                                    if (h.alumnosInscritos.contains(benefEntityId)) {
                                      isEnrolledInSelected = true;
                                      break;
                                    }
                                  }
                                }
                              }
                            }
                          }

                          if (isEnrolledInSelected) {
                            return false;
                          }
                        }

                        // Si el grupo no tiene límites de edad, TODOS pasan. Si sí los tiene y el miembro cumple, pasa.
                        return true;
                      })
                      .map((b) {
                        int? age = b['age'];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (_selectedBeneficiaries.contains(b['name'])) {
                                _selectedBeneficiaries.remove(b['name']);
                              } else {
                                _selectedBeneficiaries.add(b['name']);
                              }
                            });
                            setSheetState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Theme.of(context).textTheme.titleLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        age != null
                                            ? '$age años'
                                            : 'Edad sin proporcionar en perfil',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedBeneficiaries.contains(b['name']))
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.primaryColor,
                                  )
                                else
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.3) ?? AppTheme.neutral300,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                  if (beneficiaries.where((b) {
                    int? age = b['age'];
                    if (selectedGroup.edadMin != null &&
                        selectedGroup.edadMax != null) {
                      if (age == null) return false;
                      if (age < selectedGroup.edadMin! ||
                          age > selectedGroup.edadMax!)
                        return false;
                    } else if (selectedGroup.edadMin != null) {
                      if (age == null) return false;
                      if (age < selectedGroup.edadMin!) return false;
                    } else if (selectedGroup.edadMax != null) {
                      if (age == null) return false;
                      if (age > selectedGroup.edadMax!) return false;
                    }
                    int? benefEntityId = b['entityid'] as int?;
                    if (benefEntityId != null && benefEntityId != 0) {
                      bool isEnrolledInSelected = false;

                      for (final item in _selectedItems) {
                        final parts = item.split('-');
                        final eqId = int.tryParse(parts[0]);
                        final horId = parts.length > 1 && parts[1] != 'null' ? int.tryParse(parts[1]) : null;

                        for (final eq in selectedGroup.equipos) {
                          if (eq.id == eqId) {
                            if (horId != null) {
                              for (final h in eq.horarios) {
                                if (h.id == horId && h.alumnosInscritos.contains(benefEntityId)) {
                                  isEnrolledInSelected = true;
                                  break;
                                }
                              }
                            } else {
                              for (final h in eq.horarios) {
                                if (h.alumnosInscritos.contains(benefEntityId)) {
                                  isEnrolledInSelected = true;
                                  break;
                                }
                              }
                            }
                          }
                        }
                      }

                      if (isEnrolledInSelected) {
                        return false;
                      }
                    }
                    return true;
                  }).isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Text(
                        'Ningún miembro cumple con la edad o ya están inscritos.',
                        style: TextStyle(
                          color: AppTheme.dangerColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Listo', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
        },
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    // Preparar lista rica de integrantes familiares
    List<Map<String, dynamic>> validBeneficiaries = [];
    if (profileAsync.value != null) {
      final String rawTitular = profileAsync.value!.fullname ?? '';
      final String cleanTitular = rawTitular.replaceFirst(
        RegExp(r'^\d+\s*'),
        '',
      );

      validBeneficiaries.add({
        'id': int.tryParse(profileAsync.value!.id.toString()) ?? 0,
        'entityid': int.tryParse(profileAsync.value!.entityid.toString()) ?? 0,
        'name': cleanTitular,
        'age': profileAsync.value!.age,
      });
      for (var member in profileAsync.value!.associatedMembers) {
        if (member.fullname != null && member.fullname!.isNotEmpty) {
          final String cleanMember = member.fullname!.replaceFirst(
            RegExp(r'^\d+\s*'),
            '',
          );
          validBeneficiaries.add({
            'id': int.tryParse(member.id.toString()) ?? 0,
            'entityid': int.tryParse(member.membershipNumber.toString()) ?? 0,
            'name': cleanMember,
            'age': member.age,
          });
        }
      }
    }

    ActivityGroupModel? currentSelectedGroup;
    if (_selectedGroupId != null) {
      try {
        currentSelectedGroup = widget.activity.grupos.firstWhere(
          (g) => g.id == _selectedGroupId,
        );
      } catch (_) {}
    }

    // ── Detección temprana: ¿el beneficiario ya está inscrito en este horario?
    List<String> yaInscritosList = [];
    if (_selectedItems.isNotEmpty && _selectedBeneficiaries.isNotEmpty) {
      final parts = _selectedItems.first.split('-');
      final selHorId = parts.length > 1 && parts[1] != 'null'
          ? int.tryParse(parts[1])
          : null;
      final selEqId = int.tryParse(parts[0]);

      if (selHorId != null) {
        for (final g in widget.activity.grupos) {
          for (final eq in g.equipos) {
            if (eq.id == selEqId) {
              for (final h in eq.horarios) {
                if (h.id == selHorId) {
                  for (final bName in _selectedBeneficiaries) {
                    final benefEntityId = validBeneficiaries
                        .where((b) => b['name'] == bName)
                        .map((b) => b['entityid'] as int?)
                        .firstOrNull;
                    if (benefEntityId != null && benefEntityId != 0 &&
                        h.alumnosInscritos.contains(benefEntityId)) {
                      yaInscritosList.add(bName);
                    }
                  }
                  break;
                }
              }
            }
          }
        }
      }
    }
    bool yaInscrito = yaInscritosList.isNotEmpty;


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
              const SizedBox(height: 12),

              // ── Header compacto ──────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getColor(widget.activity.color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: (widget.activity.icono != null && widget.activity.icono!.isNotEmpty && !RegExp(r'[a-zA-Z]').hasMatch(widget.activity.icono!))
                        ? Text(widget.activity.icono!, style: const TextStyle(fontSize: 24))
                        : Icon(
                            _getIconData(widget.activity.icono),
                            color: _getColor(widget.activity.color),
                            size: 24,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.activity.nombre,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        if (widget.activity.descripcion != null)
                          Text(
                            widget.activity.descripcion!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Barra de progreso ───────────────────────────────
              _StepProgressBar(
                step1Done: _selectedItems.isNotEmpty,
                step2Done: _selectedBeneficiaries.isNotEmpty,
                step3Done: currentSelectedGroup?.requiereSeleccionLugares == true
                    ? _selectedLugares.length == _selectedBeneficiaries.length && _selectedBeneficiaries.isNotEmpty
                    : _selectedBeneficiaries.isNotEmpty,
              ),
              const SizedBox(height: 14),

              // ── Paso 1 ─────────────────────────────────────────
              _StepLabel(number: 1, label: 'Elige el día y horario', done: _selectedItems.isNotEmpty),
              const SizedBox(height: AppTheme.spacingSmall),

              if (widget.activity.grupos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusMedium,
                    ),
                  ),
                  child: Text(
                    'No hay horarios ni grupos configurados aún.',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                  ),
                )
              else
                Column(
                  children: widget.activity.grupos.map((grupo) {
                    final bool isUnlimited = !grupo.tieneCupo;
                    final bool isFull =
                        !isUnlimited && (grupo.cupoDisponible ?? 0) <= 0;
                    final bool isSelected = _selectedGroupId == grupo.id;

                    String ageText = "Libre (Cualquier Edad)";
                    if (grupo.edadMin != null && grupo.edadMax != null) {
                      ageText = "De ${grupo.edadMin} a ${grupo.edadMax} años";
                    } else if (grupo.edadMin != null) {
                      ageText = "Mayores de ${grupo.edadMin} años";
                    } else if (grupo.edadMax != null) {
                      ageText = "Menores de ${grupo.edadMax} años";
                    }

                    String spotsText = isUnlimited
                        ? "Ilimitado"
                        : (isFull
                              ? "Agotado"
                              : "${grupo.cupoDisponible} lugares");

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.03)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusGlobal,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Theme.of(context).dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded:
                              isSelected || widget.activity.grupos.length == 1,
                          onExpansionChanged: (expanded) {
                            if (expanded && !isFull) {
                              setState(() {
                                if (_selectedGroupId != grupo.id) {
                                  _selectedGroupId = grupo.id;
                                  _selectedItems.clear();
                                }
                              });
                            }
                          },
                          title: Text(
                            grupo.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isFull
                                  ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)
                                  : Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                          subtitle: Text(
                            ageText,
                            style: TextStyle(
                              color: isFull ? AppTheme.dangerColor : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: isFull ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: 12,
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: grupo.equipos.isEmpty
                              ? [
                                  const Text(
                                    'Horarios por confirmar',
                                    style: TextStyle(
                                      color: AppTheme.neutral500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ]
                              : widget.activity.tipo == 'deporte_equipo'
                              ? _buildEquipoLevelRadios(
                                  grupo,
                                  isFull,
                                ) // Torneos o deportes en bloque
                              : _buildHorarioLevelRadios(
                                  grupo,
                                  isFull,
                                ), // Clases o talleres específicos
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: AppTheme.spacingMedium),

              // ── Paso 2 ────────────────────────────────────────────────
              AnimatedOpacity(
                opacity: _selectedItems.isNotEmpty ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: _selectedItems.isEmpty || _isEnrolling,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StepLabel(
                        number: 2,
                        label: '¿Para quién es la clase?',
                        done: _selectedBeneficiaries.isNotEmpty,
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      // ── Card de beneficiario ──────────────────────────
                      InkWell(
                        onTap: () {
                          if (currentSelectedGroup != null) {
                            _openBeneficiarySelector(
                              context,
                              validBeneficiaries,
                              currentSelectedGroup!,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMedium,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedBeneficiaries.isNotEmpty
                                ? AppTheme.primaryColor.withValues(alpha: 0.05)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                            border: Border.all(
                              color: _selectedBeneficiaries.isNotEmpty
                                  ? AppTheme.primaryColor
                                  : Theme.of(context).dividerColor,
                              width: _selectedBeneficiaries.isNotEmpty ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _selectedBeneficiaries.isNotEmpty
                                      ? AppTheme.primaryColor
                                      : AppTheme.neutral100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _selectedBeneficiaries.isNotEmpty
                                      ? Icons.group_rounded
                                      : Icons.person_add_alt_1_rounded,
                                  color: _selectedBeneficiaries.isNotEmpty
                                      ? Colors.white
                                      : AppTheme.neutral500,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_selectedBeneficiaries.isNotEmpty)
                                      Text(
                                        'Asistentes seleccionados (${_selectedBeneficiaries.length})',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    Text(
                                      _selectedBeneficiaries.isNotEmpty
                                          ? _selectedBeneficiaries.join(', ')
                                          : 'Seleccionar quién asistirá',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: _selectedBeneficiaries.isNotEmpty
                                            ? FontWeight.w800
                                            : FontWeight.w500,
                                        color: _selectedBeneficiaries.isNotEmpty
                                            ? Theme.of(context).textTheme.titleLarge?.color
                                            : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                _selectedBeneficiaries.isNotEmpty
                                    ? Icons.swap_horiz_rounded
                                    : Icons.chevron_right_rounded,
                                color: _selectedBeneficiaries.isNotEmpty
                                    ? AppTheme.primaryColor
                                    : AppTheme.neutral400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingMedium),

              // ── Paso 3: Lugar ─────────────────────────────────────
              if (currentSelectedGroup?.requiereSeleccionLugares == true) ...[
                AnimatedOpacity(
                  opacity: _selectedBeneficiaries.isNotEmpty ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: _selectedBeneficiaries.isEmpty || _isEnrolling,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepLabel(
                          number: 3,
                          label: 'Elige tus lugares (${_selectedLugares.length}/${_selectedBeneficiaries.length})',
                          done: _selectedLugares.length == _selectedBeneficiaries.length && _selectedBeneficiaries.isNotEmpty,
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        _buildLugarSelector(context, currentSelectedGroup!),
                      ],
                    ),
                  ),
                ),
              ] else if (currentSelectedGroup != null) ...[
                _buildLugarSelector(context, currentSelectedGroup!),
              ],

              // --- Términos y Condiciones ---
              if (_termsStatus == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_termsStatus!.required)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLarge),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusGlobal,
                    ),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _termsAccepted
                            ? Icons.check_circle_rounded
                            : Icons.info_outline_rounded,
                        color: _termsAccepted
                            ? AppTheme.successColor
                            : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacingMedium),
                      Expanded(
                        child: Text(
                          _termsAccepted
                              ? 'Políticas aceptadas para la inscripción'
                              : 'Debe revisar y aceptar los términos de la actividad.',
                          style: TextStyle(
                            color: _termsAccepted
                                ? AppTheme.successColor
                                : AppTheme.neutral900,
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
                                  version: _termsStatus!.terminos!.version
                                      .toString(),
                                  content: _termsStatus!.terminos!.contenido,
                                  onAccept: () async {
                                    bool ok = await ref
                                        .read(termsProvider)
                                        .acceptTerms(
                                          'actividades',
                                          _termsStatus!.terminos!.version,
                                          _termsStatus!.terminos!.id,
                                        );
                                    if (ok && mounted) {
                                      _onTermsAccepted(true);
                                      Navigator.pop(context);
                                    } else if (mounted) {
                                      ToastAlerts.showError(
                                        context,
                                        'No se pudieron aceptar los términos',
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Leer',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // ── Banner: ya inscrito ──────────────────────────────────
              if (yaInscrito)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(
                        color: AppTheme.dangerColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_rounded,
                          color: AppTheme.dangerColor, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${yaInscritosList.join(', ')} ya tienen una reserva activa.',
                          style: const TextStyle(
                            color: AppTheme.dangerColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MisReservasView()),
                          );
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: AppTheme.dangerColor,
                            padding: EdgeInsets.zero),
                        child: const Text('Ver reservas',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (_selectedBeneficiaries.isNotEmpty &&
                          _termsAccepted &&
                          _selectedItems.isNotEmpty &&
                          !_isEnrolling &&
                          !yaInscrito &&
                          (!(currentSelectedGroup?.requiereSeleccionLugares ??
                                  false) ||
                              _selectedLugares.length == _selectedBeneficiaries.length))
                      ? () async {
                          setState(() => _isEnrolling = true);
                          try {
                            for (var item in _selectedItems) {
                              final parts = item.split('-');
                              final eqId = int.parse(parts[0]);
                              final horId = parts[1] == 'null'
                                  ? null
                                  : int.parse(parts[1]);

                              final lugaresList = _selectedLugares.toList();

                              for (int i = 0; i < _selectedBeneficiaries.length; i++) {
                                final bName = _selectedBeneficiaries.elementAt(i);
                                final String beneficiarySocioId =
                                    validBeneficiaries
                                        .firstWhere((b) => b['name'] == bName)['id']
                                        .toString();
                                final String finalName = bName.replaceAll(' (Titular)', '');
                                
                                String? assignedLugar;
                                if (currentSelectedGroup?.requiereSeleccionLugares == true && lugaresList.length > i) {
                                  assignedLugar = lugaresList[i];
                                }

                                await ref
                                    .read(activitiesProvider.notifier)
                                    .inscribirActividad(
                                      eqId,
                                      horId,
                                      finalName,
                                      beneficiarySocioId,
                                      lugar: assignedLugar,
                                    );
                              }
                            }

                            if (mounted) {
                              // ── Confirmación enriquecida ──────────────────
                              // Calcular fecha específica de la clase
                              final parts2 = _selectedItems.first.split('-');
                              final selectedHorId = parts2[1] == 'null'
                                  ? null
                                  : int.tryParse(parts2[1]);
                              String? fechaClaseLabel;
                              if (selectedHorId != null) {
                                final now = DateTime.now();
                                final wd =
                                    _activeDayFilters[currentSelectedGroup
                                        ?.id] ??
                                    0;
                                for (int d = 0; d < 8; d++) {
                                  final candidate = now.add(Duration(days: d));
                                  if (candidate.weekday == wd) {
                                    const meses = [
                                      '',
                                      'Ene',
                                      'Feb',
                                      'Mar',
                                      'Abr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Ago',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dic',
                                    ];
                                    const dias = [
                                      '',
                                      'Lun',
                                      'Mar',
                                      'Mié',
                                      'Jue',
                                      'Vie',
                                      'Sáb',
                                      'Dom',
                                    ];
                                    fechaClaseLabel =
                                        '${dias[candidate.weekday]} ${candidate.day} de ${meses[candidate.month]}';
                                    break;
                                  }
                                }
                              }

                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => _ConfirmacionDialog(
                                  beneficiario: _selectedBeneficiaries.join(', '),
                                  actividad: widget.activity.nombre,
                                  lugar: _selectedLugares.isNotEmpty ? _selectedLugares.join(', ') : null,
                                  horarioStr: fechaClaseLabel,
                                ),
                              );
                              if (mounted) Navigator.pop(context);
                            }
                          } catch (e) {
                            if (mounted) {
                              String err = e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              );
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
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Inscribir',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
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

  Widget _buildLugarSelector(BuildContext context, ActivityGroupModel grupo) {
    if (!grupo.requiereSeleccionLugares) return const SizedBox.shrink();
    if (_selectedItems.isEmpty) return const SizedBox.shrink();

    final selectedItemStr = _selectedItems.first;
    final parts = selectedItemStr.split('-');
    final eqId = int.parse(parts[0]);
    final horId = parts[1] == 'null' ? null : int.parse(parts[1]);

    // Encontrar el equipo
    ActivityTeamModel? equipo;
    try {
      equipo = grupo.equipos.firstWhere((e) => e.id == eqId);
    } catch (_) {}

    if (equipo == null) return const SizedBox.shrink();

    int cupoMaximo = 0;
    List<String> lugaresOcupados = [];
    ActivityAreaPlanoModel? plano;

    if (horId != null) {
      try {
        final horario = equipo.horarios.firstWhere((h) => h.id == horId);
        cupoMaximo = horario.cupoMaximo ?? 0;
        lugaresOcupados = horario.lugaresOcupados;
        plano = horario.plano;
      } catch (_) {}
    } else {
      // PREVIEW plano using any available schedule on the active day
      final int wd = _activeDayFilters[grupo.id]!;
      try {
        final firstHorarioForDay = equipo.horarios.firstWhere(
          (h) => h.diaSemana == wd,
        );
        cupoMaximo = firstHorarioForDay.cupoMaximo ?? 0;
        plano = firstHorarioForDay.plano;
      } catch (_) {
        cupoMaximo = grupo.cupoDisponible ?? 0;
      }
      // DONT show any occupied seats since they haven't picked a specific time!
      lugaresOcupados = [];
    }

    // Auto-deselect if the user picked a seat that turns out to be occupied.
    final invalidLugares = _selectedLugares.where((l) => lugaresOcupados.contains(l)).toList();
    if (invalidLugares.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedLugares.removeAll(invalidLugares));
      });
    }

    if (cupoMaximo <= 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: _isEnrolling ? 0.4 : 1.0,
          child: IgnorePointer(
            ignoring: _isEnrolling,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecciona tu Lugar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutral900,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                if (plano != null)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: plano!.columnas * 50.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(plano!.filas, (filaIndex) {
                          // Verificar si hay instructor en esta fila
                          final isInstructorRow = plano!.posiciones.any((p) => p.filaIndex == filaIndex && p.tipo == 'instructor');
                          
                          if (isInstructorRow) {
                            ActivityAreaPlanoPositionModel? instructorPos;
                            try {
                              instructorPos = plano!.posiciones.firstWhere((p) => p.filaIndex == filaIndex && p.tipo == 'instructor');
                            } catch (_) {}

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.person, color: Colors.blueAccent, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    instructorPos?.etiqueta.isNotEmpty == true ? instructorPos!.etiqueta : 'Profesor',
                                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: List.generate(plano!.columnas, (columnaIndex) {
                                ActivityAreaPlanoPositionModel? pos;
                                try {
                                  pos = plano!.posiciones.firstWhere(
                                    (p) => p.filaIndex == filaIndex && p.columnaIndex == columnaIndex,
                                  );
                                } catch (_) {}

                                if (pos == null || pos.tipo == 'vacio' || !pos.isActive) {
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: columnaIndex == plano!.columnas - 1 ? 0 : 8.0),
                                      child: const SizedBox.shrink(),
                                    )
                                  );
                                }

                                final lugarLabel = pos.etiqueta;
                                final isOccupied = lugaresOcupados.contains(lugarLabel);
                                final isSelected = _selectedLugares.contains(lugarLabel);

                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: columnaIndex == plano!.columnas - 1 ? 0 : 8.0),
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: InkWell(
                                        onTap: isOccupied
                                            ? null
                                            : () {
                                                setState(() {
                                                  if (isSelected) {
                                                    _selectedLugares.remove(lugarLabel);
                                                  } else {
                                                    if (_selectedBeneficiaries.isNotEmpty && _selectedLugares.length >= _selectedBeneficiaries.length) {
                                                      _selectedLugares.remove(_selectedLugares.first);
                                                    }
                                                    _selectedLugares.add(lugarLabel);
                                                  }
                                                });
                                              },
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isOccupied
                                                ? AppTheme.neutral200
                                                : (isSelected
                                                      ? AppTheme.primaryColor
                                                      : AppTheme.successColor.withValues(alpha: 0.15)),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isOccupied
                                                  ? AppTheme.neutral300
                                                  : (isSelected
                                                        ? AppTheme.primaryColor
                                                        : AppTheme.successColor.withValues(alpha: 0.5)),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              lugarLabel,
                                              style: TextStyle(
                                                color: isOccupied
                                                    ? AppTheme.neutral500
                                                    : (isSelected ? Colors.white : AppTheme.successColor),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: cupoMaximo,
                    itemBuilder: (context, index) {
                      final lugarLabel = (index + 1).toString();
                      final isOccupied = lugaresOcupados.contains(lugarLabel);
                      final isSelected = _selectedLugares.contains(lugarLabel);

                      return InkWell(
                        onTap: isOccupied
                            ? null
                            : () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedLugares.remove(lugarLabel);
                                  } else {
                                    if (_selectedBeneficiaries.isNotEmpty && _selectedLugares.length >= _selectedBeneficiaries.length) {
                                      _selectedLugares.remove(_selectedLugares.first);
                                    }
                                    _selectedLugares.add(lugarLabel);
                                  }
                                });
                              },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isOccupied
                                ? AppTheme.neutral200
                                : (isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isOccupied
                                  ? AppTheme.neutral300
                                  : (isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.neutral300),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              lugarLabel,
                              style: TextStyle(
                                color: isOccupied
                                    ? AppTheme.neutral500
                                    : (isSelected
                                          ? Colors.white
                                          : AppTheme.neutral900),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLarge),
      ],
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
          onTap: isFull
              ? null
              : () {
                  setState(() {
                    if (_selectedGroupId != grupo.id) {
                      _selectedGroupId = grupo.id;
                      _selectedItems.clear();
                      _selectedLugares.clear();
                    }
                    if (isChecked) {
                      _selectedItems.remove(key);
                    } else {
                      _selectedItems.add(key);
                    }
                    _selectedBeneficiaries.clear();
                    _selectedLugares.clear();
                  });
                },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isChecked
                  ? AppTheme.primaryColor.withValues(alpha: 0.08)
                  : (isFull ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isChecked
                    ? AppTheme.primaryColor
                    : (isFull ? Theme.of(context).dividerColor : Theme.of(context).dividerColor),
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
                      Text(
                        equipo.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: isFull
                              ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)
                              : (isChecked
                                    ? AppTheme.primaryColor
                                    : Theme.of(context).textTheme.titleLarge?.color),
                          fontSize: 14,
                        ),
                      ),
                      if (equipo.horarios.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Modalidad de Torneo / Equipo completo',
                            style: TextStyle(
                              fontSize: 13,
                              color: isFull
                                  ? AppTheme.neutral500
                                  : AppTheme.neutral600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: equipo.horarios.map((horario) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    size: 14,
                                    color: isFull
                                        ? AppTheme.neutral400
                                        : AppTheme.neutral600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_diaToString(horario.diaSemana)} de ${horario.horaInicio.substring(0, 5)} a ${horario.horaFin.substring(0, 5)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isFull
                                          ? AppTheme.neutral500
                                          : AppTheme.neutral700,
                                    ),
                                  ),
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
                  isChecked
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 24,
                  color: isChecked
                      ? AppTheme.primaryColor
                      : (isFull ? AppTheme.neutral300 : AppTheme.neutral400),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildHorarioLevelRadios(ActivityGroupModel grupo, bool isFull) {
    if (grupo.equipos.isEmpty) return [];

    if (_selectedGroupId == null && widget.activity.grupos.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedGroupId = grupo.id);
      });
    }

    Map<int, List<Map<String, dynamic>>> schedulesByDay =
        {}; // keyed by diaSemana
    bool hasSchedules = false;
    for (var equipo in grupo.equipos) {
      if (equipo.horarios.isEmpty) continue;
      for (var horario in equipo.horarios) {
        hasSchedules = true;
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

    if (!hasSchedules) return [];

    // Map `diaSemana` to upcoming dates (next 7 days)
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> upcomingDates = [];

    for (int i = 0; i < 7; i++) {
      DateTime targetDate = now.add(Duration(days: i));
      int targetWeekday = targetDate.weekday; // 1 = Mon, 7 = Sun

      if (schedulesByDay.containsKey(targetWeekday)) {
        // filter out passed times if it's today
        List<Map<String, dynamic>> validSchedules = [];
        for (var sched in schedulesByDay[targetWeekday]!) {
          bool hasPassed = false;
          if (i == 0) {
            try {
              final parts = sched['hora_inicio'].split(':');
              final schedTime = DateTime(
                now.year,
                now.month,
                now.day,
                int.parse(parts[0]),
                int.parse(parts[1]),
              );
              if (schedTime.isBefore(now)) {
                hasPassed = true;
              }
            } catch (_) {}
          }
          if (!hasPassed) {
            validSchedules.add(sched);
          }
        }

        if (validSchedules.isNotEmpty) {
          upcomingDates.add({
            'date': targetDate,
            'weekday': targetWeekday,
            'schedules': validSchedules,
            'dateStr':
                '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}',
          });
        }
      }
    }

    if (upcomingDates.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No hay clases disponibles en los próximos 7 días.",
            style: TextStyle(color: AppTheme.neutral500),
          ),
        ),
      ];
    }

    // Set initial active date string to first available if not set
    if (!_activeDayFilters.containsKey(grupo.id)) {
      _activeDayFilters[grupo.id] = upcomingDates.first['weekday'];
    }

    int currentWeekday = _activeDayFilters[grupo.id]!;
    // verify the current weekday still exists in valid upcoming dates
    if (!upcomingDates.any((d) => d['weekday'] == currentWeekday)) {
      currentWeekday = upcomingDates.first['weekday'];
      _activeDayFilters[grupo.id] = currentWeekday;
    }

    final activeDateObj = upcomingDates.firstWhere(
      (d) => d['weekday'] == currentWeekday,
    );
    List<Map<String, dynamic>> currentSchedules = activeDateObj['schedules'];
    currentSchedules.sort(
      (a, b) =>
          (a['hora_inicio'] as String).compareTo(b['hora_inicio'] as String),
    );

    List<Widget> children = [];

    // Horizontal Scrollable Day Selector (Pills)
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: upcomingDates.map((dateObj) {
              DateTime d = dateObj['date'];
              int wd = dateObj['weekday'];
              final isSelected = currentWeekday == wd;

              String dateLabel = "";
              if (d.year == now.year &&
                  d.month == now.month &&
                  d.day == now.day) {
                dateLabel = "Hoy, ${_shortDia(wd)} ${d.day}";
              } else if (d.year == now.year &&
                  d.month == now.month &&
                  d.day == now.add(const Duration(days: 1)).day) {
                dateLabel = "Mañana, ${_shortDia(wd)} ${d.day}";
              } else {
                List<String> months = [
                  'Ene',
                  'Feb',
                  'Mar',
                  'Abr',
                  'May',
                  'Jun',
                  'Jul',
                  'Ago',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dic',
                ];
                dateLabel =
                    "${_shortDia(wd)} ${d.day} de ${months[d.month - 1]}";
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                    dateLabel,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppTheme.neutral700,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.neutral100,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                  onSelected: (val) {
                    if (val && !isSelected) {
                      setState(() {
                        _activeDayFilters[grupo.id] = wd;
                        _selectedItems
                            .clear(); // Limpiar el horario seleccionado del dia anterior
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    List<Widget> chips = currentSchedules.map((sched) {
      final key = "${sched['equipo_id']}-${sched['horario_id']}";
      final isChecked = _selectedItems.contains(key);
      final timeStr =
          "${(sched['hora_inicio'] as String).substring(0, 5)} - ${(sched['hora_fin'] as String).substring(0, 5)} hrs";

      final bool tieneCupo = sched['tiene_cupo'] as bool? ?? false;
      final int? cupoDisp = sched['cupo_disponible'] as int?;
      final bool isHorarioFull = tieneCupo && cupoDisp != null && cupoDisp <= 0;
      final bool isDisabled = isFull || isHorarioFull;

      return InkWell(
        onTap: isDisabled
            ? null
            : () {
                setState(() {
                  if (_selectedGroupId != grupo.id) {
                    _selectedGroupId = grupo.id;
                    _selectedItems.clear();
                  }
                  if (isChecked) {
                    _selectedItems.remove(key);
                  } else {
                    _selectedItems.removeWhere((item) {
                      final parts = item.split('-');
                      if (parts.length != 2) return false;
                      int eqId = int.parse(parts[0]);
                      int? hId = parts[1] == 'null'
                          ? null
                          : int.parse(parts[1]);
                      return currentSchedules.any(
                        (s) => s['equipo_id'] == eqId && s['horario_id'] == hId,
                      );
                    });
                    _selectedItems.add(key);
                  }
                  // Bugfix: Evitar resetear beneficiario y lugar
                });
              },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isChecked
                ? AppTheme.primaryColor.withValues(alpha: 0.08)
                : (isDisabled ? AppTheme.neutral100 : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isChecked
                  ? AppTheme.primaryColor
                  : (isDisabled ? AppTheme.neutral200 : AppTheme.neutral300),
              width: isChecked ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isChecked
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 18,
                color: isChecked
                    ? AppTheme.primaryColor
                    : (isDisabled ? AppTheme.neutral300 : AppTheme.neutral400),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: isChecked
                            ? AppTheme.primaryColor
                            : (isDisabled
                                  ? AppTheme.neutral400
                                  : AppTheme.neutral800),
                        fontWeight: isChecked
                            ? FontWeight.w900
                            : FontWeight.w600,
                        fontSize: 12,
                        decoration: isHorarioFull
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                    ),
                    if (tieneCupo && cupoDisp != null)
                      Text(
                        isHorarioFull ? 'Agotado' : '$cupoDisp lugares',
                        style: TextStyle(
                          color: isHorarioFull
                              ? AppTheme.dangerColor
                              : (cupoDisp <= 3
                                    ? Colors.orange
                                    : AppTheme.secondaryColor),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
      LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 8) / 2;
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: chips
                .map((c) => SizedBox(width: itemWidth, child: c))
                .toList(),
          );
        },
      ),
    );

    children.add(const SizedBox(height: 8));
    return children;
  }
}

// ── Diálogo de Confirmación post-inscripción ──────────────────────────────────
class _ConfirmacionDialog extends StatelessWidget {
  final String beneficiario;
  final String actividad;
  final String? lugar;
  final String? horarioStr;

  const _ConfirmacionDialog({
    required this.beneficiario,
    required this.actividad,
    this.lugar,
    this.horarioStr,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Icono
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppTheme.successColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '¡Reserva confirmada!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              beneficiario,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // ── Info card ──────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(context, Icons.fitness_center_rounded, actividad),
                  if (horarioStr != null) ...[
                    const SizedBox(height: 8),
                    _row(context, Icons.calendar_today_rounded, horarioStr!),
                  ],
                  if (lugar != null) ...[
                    const SizedBox(height: 8),
                    _row(
                      context,
                      Icons.event_seat_rounded,
                      'Lugar: $lugar',
                      highlight: true,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              'Tu reserva se ha registrado exitosamente. Podrás consultar el detalle de tus clases y horarios en la sección Mis Actividades del menú principal.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            // ── Botones ────────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String text, {bool highlight = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: highlight ? AppTheme.primaryColor : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              color: highlight ? AppTheme.primaryColor : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Step Progress Bar ────────────────────────────────────────────────────────
class _StepProgressBar extends StatelessWidget {
  final bool step1Done;
  final bool step2Done;
  final bool step3Done;

  const _StepProgressBar({
    required this.step1Done,
    required this.step2Done,
    required this.step3Done,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepDot(number: 1, done: step1Done, active: true, label: 'Horario'),
        _StepConnector(done: step1Done),
        _StepDot(
            number: 2,
            done: step2Done,
            active: step1Done,
            label: 'Beneficiario'),
        _StepConnector(done: step2Done),
        _StepDot(
            number: 3,
            done: step3Done,
            active: step2Done,
            label: 'Confirmar'),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final bool done;
  final bool active;
  final String label;

  const _StepDot({
    required this.number,
    required this.done,
    required this.active,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = done
        ? AppTheme.successColor
        : active
            ? AppTheme.primaryColor
            : AppTheme.neutral300;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: done ? AppTheme.successColor : (active ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surfaceContainerHighest),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: active ? AppTheme.primaryColor : AppTheme.neutral400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: done
                  ? AppTheme.successColor
                  : active
                      ? AppTheme.primaryColor
                      : AppTheme.neutral400,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool done;
  const _StepConnector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: 2,
          color: done ? AppTheme.successColor : Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}

// ── Step Label ───────────────────────────────────────────────────────────────
class _StepLabel extends StatelessWidget {
  final int number;
  final String label;
  final bool done;

  const _StepLabel({
    required this.number,
    required this.label,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: done ? AppTheme.successColor : AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: done ? AppTheme.successColor : Theme.of(context).textTheme.titleLarge?.color,
              ),
        ),
        if (done) ...[
          const SizedBox(width: 6),
          const Icon(Icons.check_circle_outline_rounded,
              size: 14, color: AppTheme.successColor),
        ],
      ],
    );
  }
}
