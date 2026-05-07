class FamilyAgendaItem {
  final int id;
  final String tipo; // 'clase' o 'partido'
  final int timestamp;
  final String timeBlock;
  final String durationStr;
  final String title;
  final String subtitle;
  final String personName;
  final String socioId;
  final String icon;
  final String colorHex;
  final bool isMatch;

  FamilyAgendaItem({
    required this.id,
    required this.tipo,
    required this.timestamp,
    required this.timeBlock,
    required this.durationStr,
    required this.title,
    required this.subtitle,
    required this.personName,
    required this.socioId,
    required this.icon,
    required this.colorHex,
    required this.isMatch,
  });

  factory FamilyAgendaItem.fromJson(Map<String, dynamic> json) {
    return FamilyAgendaItem(
      id: json['id'] ?? 0,
      tipo: json['tipo'] ?? 'clase',
      timestamp: json['timestamp'] ?? 0,
      timeBlock: json['time_block'] ?? '',
      durationStr: json['duration_str'] ?? '1.0 hrs',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      personName: json['person_name'] ?? '',
      socioId: json['socio_id']?.toString() ?? '',
      icon: json['icon'] ?? 'event',
      colorHex: json['color_hex'] ?? '#333333',
      isMatch: json['is_match'] ?? false,
    );
  }
}
