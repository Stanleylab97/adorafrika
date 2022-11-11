class Panegyrique{
  late String name, region, url, statut, fichier_audio, type;

  Panegyrique({required this.name, required this.region, required this.statut,  required this.fichier_audio ,required this.url, required this.type});


  static Panegyrique fromJson(json)=> Panegyrique(
    name: json['nom_famille'],
     region: json['region'], 
     statut: json['statut'], 
     fichier_audio: json['fichier_audio'],
     type: json['type_fichier'],
     url: "");
}