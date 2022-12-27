class Panegyrique {
  late String name, region, url, statut, fichier_audio, type;
  String? countryCode;

  Panegyrique(
      {required this.name,
      required this.region,
      required this.statut,
      required this.fichier_audio,
      this.countryCode,
      required this.url,
      required this.type});

  static Panegyrique fromJson(json) => Panegyrique(
      name: json['nom_famille'],
      region: json['region'],
      statut: json['statut'],
      countryCode: json['country'],
      fichier_audio: json['fichier'],
      type: json['type_fichier'],
      url: "");
}
