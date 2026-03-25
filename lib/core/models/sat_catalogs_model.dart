class SatCatalogsModel {
  final List<SatRegimenFiscal> regimenesFiscales;
  final List<SatUsoCfdi> usosCfdi;

  SatCatalogsModel({
    required this.regimenesFiscales,
    required this.usosCfdi,
  });

  factory SatCatalogsModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'] ?? {};
    var regimenesList = data['regimenes_fiscales'] as List? ?? [];
    var usosCfdiList = data['uso_cfdi'] as List? ?? [];

    return SatCatalogsModel(
      regimenesFiscales: regimenesList.map((e) => SatRegimenFiscal.fromJson(e)).toList(),
      usosCfdi: usosCfdiList.map((e) => SatUsoCfdi.fromJson(e)).toList(),
    );
  }
}

class SatRegimenFiscal {
  final String clave;
  final String descripcion;

  SatRegimenFiscal({
    required this.clave,
    required this.descripcion,
  });

  factory SatRegimenFiscal.fromJson(Map<String, dynamic> json) {
    return SatRegimenFiscal(
      clave: json['clave'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }
  
  String get displayString => '$clave - $descripcion';
}

class SatUsoCfdi {
  final String clave;
  final String descripcion;
  final bool aplicaFisica;
  final bool aplicaMoral;
  final String regimenesReceptor;

  SatUsoCfdi({
    required this.clave,
    required this.descripcion,
    required this.aplicaFisica,
    required this.aplicaMoral,
    required this.regimenesReceptor,
  });

  factory SatUsoCfdi.fromJson(Map<String, dynamic> json) {
    return SatUsoCfdi(
      clave: json['clave'] ?? '',
      descripcion: json['descripcion'] ?? '',
      aplicaFisica: json['aplica_fisica'] ?? false,
      aplicaMoral: json['aplica_moral'] ?? false,
      regimenesReceptor: json['regimenes_receptor'] ?? '',
    );
  }

  String get displayString => '$clave - $descripcion';
}
