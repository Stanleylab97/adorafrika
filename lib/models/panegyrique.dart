class Panegyrique {
  late String name,useriD, state, region, url, statut, fichier_audio, type;
  String? countryCode;

  Panegyrique(
      {required this.name,
      required this.region,
      required this.statut,
      required this.fichier_audio,
      this.countryCode,
      required this.state,
      required this.useriD,
      required this.url,
      required this.type});

  static Panegyrique fromJson(json) => Panegyrique(
      name: json['nom_famille'],
      region: json['region'],
      statut: json['statut'],
      countryCode: json['pays'],
      fichier_audio: json['fichier'],
      type: json['type_fichier'],
      url: "",
      state:json['state'] ,
      useriD:json['compte_clients_id']
      );
}
