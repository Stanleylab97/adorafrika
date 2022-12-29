class Panegyrique {
  late String name,username, state, region,  statut, fichier, type;
  String? countryCode,thumbnail;
  late int id, isPanegyric;

  Panegyrique(
      {required this.name,
      required this.region,
      required this.statut,
      required this.fichier,
      this.countryCode,
      required this.id,
      required this.state,
      required this.username,
      required this.thumbnail,
      required this.type,
      required this.isPanegyric});

  static Panegyrique fromJson(json) => Panegyrique(
      id:json['id'],
      name: json['nom_famille'],
      region: json['region'],
      statut: json['statut']==null?"":json['statut'],
      countryCode: json['pays'],
      fichier: json['fichier'],
      type: json['type_fichier'],
      thumbnail: json['thumbnail'],
      state: json['state'] ,
      username:json['compte_client']['username'],
isPanegyric: json['isPanegyric']
      );
}
