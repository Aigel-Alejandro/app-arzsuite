import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_arzsuite/core/providers/api_client_notifier.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
import 'package:app_arzsuite/features/tournaments/models/tournament_model.dart';
import 'package:intl/intl.dart';

class TournamentMyDetailView extends ConsumerStatefulWidget {
  final TournamentModel tournament;

  const TournamentMyDetailView({super.key, required this.tournament});

  @override
  ConsumerState<TournamentMyDetailView> createState() => _TournamentMyDetailViewState();
}

class _TournamentMyDetailViewState extends ConsumerState<TournamentMyDetailView> {
  // Guardamos temporalmente el marcador editado para propósitos visuales antes de conectarlo a la BD
  final Map<int, List<int>> _localScores = {};

  void _openScoreDialog(TournamentMatchModel match) {
    final localCtrl = TextEditingController();
    final visitCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ingresar Marcador', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Partido vs ${match.rivalNombre}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Local', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: localCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(' - ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Column(
                    children: [
                      const Text('Visitante', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: visitCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.neutral500)),
            ),
            ElevatedButton(
              onPressed: () {
                if (localCtrl.text.isNotEmpty && visitCtrl.text.isNotEmpty) {
                  setState(() {
                    _localScores[match.id] = [int.parse(localCtrl.text), int.parse(visitCtrl.text)];
                  });
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Marcador guardado')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUserCaptain = false;
    String capitanNombre = 'No asignado';
    
    if (widget.tournament.equiposDisponibles.isNotEmpty) {
      final myCaptainTeam = widget.tournament.equiposDisponibles.where((t) => t.isUserCaptain).firstOrNull;
      
      if (myCaptainTeam != null) {
        isUserCaptain = true;
        capitanNombre = (myCaptainTeam.capitanActual?.isNotEmpty == true) ? myCaptainTeam.capitanActual! : 'Tú (Capitán)';
      } else {
        final anyTeamWithCaptain = widget.tournament.equiposDisponibles.where((t) => t.capitanActual?.isNotEmpty == true).firstOrNull;
        if (anyTeamWithCaptain != null) {
          capitanNombre = anyTeamWithCaptain.capitanActual!;
        }
      }
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Detalle de mi Torneo', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.neutral900 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.emoji_events, color: Colors.deepPurple, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tournament.nombre,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.tournament.actividadNombre ?? 'Deportes',
                              style: TextStyle(color: Colors.deepPurple.shade300, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),
                  _buildInfoRow(Icons.place, 'Sede', widget.tournament.sede ?? 'Centro Libanés'),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.calendar_today, 
                    'Fechas', 
                    '${widget.tournament.fechaInicio ?? 'TBD'} al ${widget.tournament.fechaFin ?? 'TBD'}'
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.security, 
                    'Capitán', 
                    capitanNombre,
                    isHighlight: isUserCaptain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Participantes
            const Text(
              'PARTICIPANTES',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5, color: AppTheme.neutral500),
            ),
            const SizedBox(height: 12),
            if (widget.tournament.participantes.isEmpty)
              const Text('No hay participantes registrados.', style: TextStyle(color: AppTheme.neutral500))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.tournament.participantes.map((p) => Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.deepPurple.shade100, child: Text(p.nombre[0], style: const TextStyle(color: Colors.deepPurple, fontSize: 10, fontWeight: FontWeight.bold))),
                  label: Text('${p.nombre}${p.edad != null ? ' (${p.edad} años)' : ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  backgroundColor: isDark ? AppTheme.neutral800 : AppTheme.neutral100,
                  side: BorderSide.none,
                )).toList(),
              ),

            const SizedBox(height: 32),

            // Partidos
            const Text(
              'MIS PARTIDOS',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5, color: AppTheme.neutral500),
            ),
            const SizedBox(height: 12),
            if (widget.tournament.partidos.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.neutral900 : AppTheme.neutral100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.sports_score, size: 48, color: AppTheme.neutral400),
                    SizedBox(height: 16),
                    Text('Aún no hay partidos programados', style: TextStyle(color: AppTheme.neutral500, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            else
              ...widget.tournament.partidos.map((match) {
                // Solo habilitar si explícitamente el estado del partido es finalizado
                bool matchPassed = match.estado == 'finalizado';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.neutral900 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.neutral200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 16, color: Colors.deepPurple),
                              const SizedBox(width: 8),
                              Text(match.fecha != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(match.fecha!)) : 'Por definir', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: matchPassed ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              matchPassed ? 'Finalizado' : 'Próximo',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: matchPassed ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          final tempScore = _localScores[match.id];
                          final int? gl = tempScore?[0] ?? match.golesLocal;
                          final int? gv = tempScore?[1] ?? match.golesVisitante;

                          // Controladores locales si vamos a editar en la misma tarjeta
                          final localCtrl = TextEditingController(text: gl?.toString() ?? '');
                          final visitCtrl = TextEditingController(text: gv?.toString() ?? '');

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.deepPurple.shade100,
                                          child: const Icon(Icons.shield, color: Colors.deepPurple),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text('Mi Equipo', style: TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                  
                                  // --- ÁREA CENTRAL: MARCADOR O VS ---
                                  if (isUserCaptain && matchPassed) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppTheme.neutral800 : AppTheme.neutral100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: TextField(
                                              controller: localCtrl,
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                filled: true,
                                                fillColor: isDark ? AppTheme.neutral900 : Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            child: Text('-', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppTheme.neutral500)),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: TextField(
                                              controller: visitCtrl,
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                filled: true,
                                                fillColor: isDark ? AppTheme.neutral900 : Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else if (gl != null && gv != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppTheme.neutral800 : AppTheme.neutral100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$gl - $gv',
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                                      ),
                                    ),
                                  ] else ...[
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: Text('VS', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.neutral400, fontSize: 16)),
                                    ),
                                  ],
                                  // -----------------------------------

                                  Expanded(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppTheme.neutral200,
                                          child: const Icon(Icons.shield_outlined, color: AppTheme.neutral600),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(match.rivalNombre, style: const TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // BOTÓN GUARDAR (Si el capitán está editando)
                              if (isUserCaptain && matchPassed) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      if (localCtrl.text.isNotEmpty && visitCtrl.text.isNotEmpty) {
                                        final int gl = int.parse(localCtrl.text);
                                        final int gv = int.parse(visitCtrl.text);
                                        
                                        try {
                                          final apiClient = ref.read(apiClientNotifierProvider);
                                          await apiClient.dio.post('arzsuite/torneos/reportarMarcador', data: {
                                            'partido_id': match.id,
                                            'goles_local': gl,
                                            'goles_visitante': gv,
                                            'es_local': match.esLocal,
                                          });

                                          if (mounted) {
                                            setState(() {
                                              _localScores[match.id] = [gl, gv];
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Marcador registrado en la plataforma', style: TextStyle(fontWeight: FontWeight.bold))),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('No pudimos guardar el marcador en línea.')),
                                            );
                                          }
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Por favor llena ambos marcadores')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.check_circle_outline),
                                    label: const Text('Guardar Marcador'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        }
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.neutral400),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.neutral500)),
            Text(
              value, 
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isHighlight ? AppTheme.primaryColor : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
