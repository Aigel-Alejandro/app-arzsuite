class MatchModel {
  final int convocatoriaId;
  final int partidoId;
  final String torneoNombre;
  final String equipoNuestro;
  final String equipoRival;
  final String fecha;
  final String lugar;
  final bool esLocal;
  final int? golesLocal;
  final int? golesVisitante;
  final String estadoPartido;
  final String estadoConfirmacion;

  MatchModel({
    required this.convocatoriaId,
    required this.partidoId,
    required this.torneoNombre,
    required this.equipoNuestro,
    required this.equipoRival,
    required this.fecha,
    required this.lugar,
    required this.esLocal,
    this.golesLocal,
    this.golesVisitante,
    required this.estadoPartido,
    required this.estadoConfirmacion,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      convocatoriaId: json['convocatoria_id'],
      partidoId: json['partido_id'],
      torneoNombre: json['torneo_nombre'],
      equipoNuestro: json['equipo_nuestro'],
      equipoRival: json['equipo_rival'],
      fecha: json['fecha'],
      lugar: json['lugar'],
      esLocal: json['es_local'],
      golesLocal: json['goles_local'],
      golesVisitante: json['goles_visitante'],
      estadoPartido: json['estado_partido'],
      estadoConfirmacion: json['estado_confirmacion'],
    );
  }
}
