class Panegyrique {
  late String name,username, state, region, url, statut, fichier, type;
  String? countryCode;
  late int id;

  Panegyrique(
      {required this.name,
      required this.region,
      required this.statut,
      required this.fichier,
      this.countryCode,
      required this.id,
      required this.state,
      required this.username,
      required this.url,
      required this.type});

  static Panegyrique fromJson(json) => Panegyrique(
      id:json['id'],
      name: json['nom_famille'],
      region: json['region'],
      statut: json['statut']==null?"":json['statut'],
      countryCode: json['pays'],
      fichier: json['fichier'],
      type: json['type_fichier'],
      url: "",
      state:json['state'] ,
      username:json['compte_client']['username']
      );
}
