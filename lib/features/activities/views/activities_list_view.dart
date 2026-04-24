import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/core/widgets/responsive_container.dart';
import 'package:app_arzsuite/core/widgets/main_layout.dart';
import 'package:app_arzsuite/features/activities/views/activity_subscription_view.dart';
import '../providers/activities_provider.dart';
import '../../../core/providers/auth_provider.dart';

class ActivitiesListView extends ConsumerStatefulWidget {
  final bool isSubscribed;
  final bool useLayout;
  const ActivitiesListView({super.key, required this.isSubscribed, this.useLayout = true});

  @override
  ConsumerState<ActivitiesListView> createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends ConsumerState<ActivitiesListView> {
  // Filtros
  String? _selectedClub;
  String? _selectedTipo;
  bool? _tieneCostoFilter;
  bool _onlyWithSpots = false;

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.sports;
    switch (iconName) {
      case 'sports_soccer': return Icons.sports_soccer;
      case 'pool': return Icons.pool;
      case 'sports_tennis': return Icons.sports_tennis;
      case 'self_improvement': return Icons.self_improvement;
      // Añadir más de ser necesario en el futuro
      default: return Icons.sports;
    }
  }

  Color _getColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return const Color(0xFF406EBA);
    String hexString = colorHex.replaceAll('#', '0xFF');
    if (hexString.length == 10) {
      return Color(int.parse(hexString));
    }
    return const Color(0xFF406EBA);
  }

  void _resetFilters() {
    setState(() {
      _selectedClub = null;
      _selectedTipo = null;
      _tieneCostoFilter = null;
      _onlyWithSpots = false;
    });
  }

  String _formatLabel(String text) {
    if (text.isEmpty) return text;
    String spaced = text.replaceAll('_', ' ').toLowerCase();
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  void _showFilterBottomSheet(BuildContext context, List<dynamic> activities) {
    final clubs = activities.map((a) => a.clubName as String?).where((c) => c != null && c.isNotEmpty).toSet().toList();
    final tipos = activities.map((a) => a.tipo as String?).where((t) => t != null && t.isNotEmpty).toSet().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusGlobal)),
      ),
      builder: (BottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppTheme.spacingLarge,
                right: AppTheme.spacingLarge,
                top: AppTheme.spacingLarge,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spacingLarge,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtrar Actividades',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.neutral900,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  if (clubs.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingMedium),
                    const Text('Sede / Club', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: 8.0,
                      children: clubs.map((club) {
                        final isSelected = _selectedClub == club;
                        return ChoiceChip(
                          label: Text(club!),
                          selected: isSelected,
                          onSelected: (selected) {
                            setSheetState(() => _selectedClub = selected ? club : null);
                            setState(() => _selectedClub = selected ? club : null);
                          },
                          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : AppTheme.neutral700,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (tipos.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingMedium),
                    const Text('Tipo Categoria', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: 8.0,
                      children: tipos.map((tipo) {
                        final isSelected = _selectedTipo == tipo;
                        return ChoiceChip(
                          label: Text(_formatLabel(tipo!)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setSheetState(() => _selectedTipo = selected ? tipo : null);
                            setState(() => _selectedTipo = selected ? tipo : null);
                          },
                          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : AppTheme.neutral700,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingMedium),
                  const Text('Costo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingSmall),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      ChoiceChip(
                        label: const Text('Todos'),
                        selected: _tieneCostoFilter == null,
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() => _tieneCostoFilter = null);
                            setState(() => _tieneCostoFilter = null);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Con Costo'),
                        selected: _tieneCostoFilter == true,
                        onSelected: (selected) {
                          setSheetState(() => _tieneCostoFilter = selected ? true : null);
                          setState(() => _tieneCostoFilter = selected ? true : null);
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Sin Costo'),
                        selected: _tieneCostoFilter == false,
                        onSelected: (selected) {
                          setSheetState(() => _tieneCostoFilter = selected ? false : null);
                          setState(() => _tieneCostoFilter = selected ? false : null);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  SwitchListTile(
                    title: const Text('Solo actividades con cupo', style: TextStyle(fontWeight: FontWeight.bold)),
                    contentPadding: EdgeInsets.zero,
                    value: _onlyWithSpots,
                    onChanged: (val) {
                      setSheetState(() => _onlyWithSpots = val);
                      setState(() => _onlyWithSpots = val);
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        setSheetState(() {
                          _selectedClub = null;
                          _selectedTipo = null;
                          _tieneCostoFilter = null;
                          _onlyWithSpots = false;
                        });
                        _resetFilters();
                      },
                      child: const Text('Limpiar Filtros', style: TextStyle(color: AppTheme.dangerColor)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color institutionalBlue = Color(0xFF406EBA);
    final currentMember = ref.watch(authProvider);
    final hasEnrollPermission = currentMember?.hasPermission('activities.enroll') ?? false;
    
    final asyncActivities = ref.watch(activitiesProvider);

    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingLarge),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isSubscribed ? 'Mis Inscripciones' : 'Catálogo de Actividades',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.neutral900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isSubscribed 
                            ? 'Gestiona tus actividades y mantente al tanto de tus horarios.'
                            : 'Explora y únete a las diversas disciplinas que ofrecemos.',
                          style: const TextStyle(color: AppTheme.neutral500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.isSubscribed)
                    asyncActivities.maybeWhen(
                      data: (activities) {
                        bool hasActiveFilters = _selectedClub != null || _selectedTipo != null || _tieneCostoFilter != null || _onlyWithSpots;
                        return Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.filter_list_rounded, color: AppTheme.neutral700),
                              onPressed: () => _showFilterBottomSheet(context, activities),
                            ),
                            if (hasActiveFilters)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLarge),
            
            asyncActivities.when(
              data: (activities) {
                if (activities.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppTheme.spacingLarge),
                    child: Center(child: Text("No hay actividades disponibles en este momento.", style: TextStyle(color: AppTheme.neutral500))),
                  );
                }

                // Aplicar filtros
                var filteredActivities = activities;
                if (!widget.isSubscribed) {
                  filteredActivities = activities.where((activity) {
                    if (_selectedClub != null && activity.clubName != _selectedClub) return false;
                    if (_selectedTipo != null && activity.tipo != _selectedTipo) return false;
                    if (_tieneCostoFilter != null && activity.tieneCosto != _tieneCostoFilter) return false;
                    if (_onlyWithSpots) {
                       if (activity.grupos.isEmpty) return false;
                       bool hasAnySpot = activity.grupos.any((g) {
                         return g.tieneCupo && (g.cupoDisponible == null || g.cupoDisponible! > 0);
                       });
                       if (!hasAnySpot) return false;
                    }
                    return true;
                  }).toList();
                }
                
                if (filteredActivities.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppTheme.spacingLarge),
                    child: Center(child: Text("No se encontraron actividades con los filtros seleccionados.", style: TextStyle(color: AppTheme.neutral500))),
                  );
                }
                
                return Column(
                  children: filteredActivities.map((activity) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                      child: _PremiumActivityCard(
                        activity: activity,
                        title: activity.nombre,
                        description: activity.descripcion,
                        emojiIcon: activity.icono,
                        instructor: activity.clubName ?? 'Centro Libanés',
                        schedule: 'Toca para ver grupos y horarios disponibles',
                        icon: _getIconData(activity.icono),
                        accentColor: _getColor(activity.color),
                        spotsAvailable: widget.isSubscribed ? null : (
                          activity.grupos.isEmpty ? null : 
                          activity.grupos.any((g) => !g.tieneCupo) ? null : 
                          activity.grupos.fold<int>(0, (int sum, g) => sum + (g.cupoDisponible ?? 0))
                        ),
                        isSubscribed: widget.isSubscribed,
                        hasEnrollPermission: hasEnrollPermission,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: institutionalBlue),
                ),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Text('Error: ${err}', style: const TextStyle(color: AppTheme.dangerColor)),
              ),
            ),
            
            Builder(
              builder: (context) {
                final bool isMobile = MediaQuery.of(context).size.width < AppTheme.breakpointTablet;
                return SizedBox(height: isMobile ? 120 : 48);
              }
            ),
          ],
        ),
      ),
    );

    if (!widget.useLayout) return content;

    return MainLayout(
      activeIndex: 1, 
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.isSubscribed ? 'Mis Actividades' : 'Actividades Disponibles'),
          centerTitle: true,
        ),
        body: content,
      ),
    );
  }
}

class _PremiumActivityCard extends StatefulWidget {
  final dynamic activity; // ActivityModel
  final String title;
  final String? description;
  final String? emojiIcon;
  final String instructor;
  final String schedule;
  final IconData icon;
  final Color accentColor;
  final int? spotsAvailable;
  final bool isSubscribed;
  final bool hasEnrollPermission;

  const _PremiumActivityCard({
    required this.activity,
    required this.title,
    this.description,
    this.emojiIcon,
    required this.instructor,
    required this.schedule,
    required this.icon,
    required this.accentColor,
    this.spotsAvailable,
    required this.isSubscribed,
    this.hasEnrollPermission = true,
  });

  @override
  State<_PremiumActivityCard> createState() => _PremiumActivityCardState();
}

class _PremiumActivityCardState extends State<_PremiumActivityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isFull = widget.spotsAvailable == 0;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                ? widget.accentColor.withValues(alpha: 0.15) 
                : Theme.of(context).shadowColor.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 25 : 15,
              offset: Offset(0, _isHovered ? 12 : 8),
            )
          ],
          border: Border.all(
            color: _isHovered ? widget.accentColor.withValues(alpha: 0.3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            if (!widget.isSubscribed && !isFull && widget.hasEnrollPermission) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ActivitySubscriptionView(activity: widget.activity),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else if (!widget.hasEnrollPermission && !widget.isSubscribed) {
               // Feedback visual si intentan inscribirse y es Solo Lectura
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('No tienes los permisos para inscribirte a actividades. Contacta al Titular.')),
               );
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icono de Actividad
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: (widget.emojiIcon != null && widget.emojiIcon!.isNotEmpty && !RegExp(r'[a-zA-Z]').hasMatch(widget.emojiIcon!))
                          ? Text(widget.emojiIcon!, style: const TextStyle(fontSize: 24))
                          : Icon(widget.icon, color: widget.accentColor, size: 28),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (widget.description != null && widget.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.description!,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person_outline_rounded, size: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)),
                              const SizedBox(width: 4),
                              Text(
                                widget.instructor,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), 
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.payments_outlined, 
                                size: 14, 
                                color: widget.activity.tieneCosto ? AppTheme.warningColor : AppTheme.successColor,
                              ),
                              const SizedBox(width: 4),
                                Text(
                                  widget.activity.tieneCosto 
                                      ? (widget.activity.monto != null ? '\$${widget.activity.monto!.toStringAsFixed(2)} MXN' : 'Con Costo') 
                                      : 'Sin costo',
                                  style: TextStyle(
                                    color: widget.activity.tieneCosto ? Theme.of(context).textTheme.bodyLarge?.color : AppTheme.successColor, 
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Etiqueta de Estado
                    if (widget.isSubscribed)
                      _StatusChip(
                        label: 'Suscrito',
                        color: AppTheme.successColor,
                      )
                    else if (isFull)
                      _StatusChip(
                        label: 'Agotado',
                        color: AppTheme.dangerColor,
                      )
                    else
                      _StatusChip(
                        label: widget.spotsAvailable == null ? 'Disponible' : '${widget.spotsAvailable} Lugares',
                        color: AppTheme.primaryColor,
                      ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMedium),
                  child: Divider(color: Theme.of(context).dividerColor, height: 1),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Horario
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HORARIO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.schedule,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Botón de Acción
                    if (widget.isSubscribed)
                      ElevatedButton(
                        onPressed: () {}, // Ver chats/detalles
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.neutral900,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Ver Chats', 
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)
                        ),
                      )
                    else if (!isFull && widget.hasEnrollPermission)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: widget.accentColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

