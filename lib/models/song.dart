class Song {
  late String? title, typefile, thumnail, country, rythme, file, author,yearofproduction;

  Song(
      {this.title,
      this.typefile,
      this.thumnail,
      this.country,
      this.rythme,
      this.file,
      this.author,
      this.yearofproduction
      });

     static  bool isNotNull(String? input) {
    return input?.isNotEmpty ?? false;
  }
  static Song fromJson(json) => Song(
        title: json['titre'],
        typefile: json['typefile'],
        thumnail: isNotNull(json['thumbnail']) ?  json['thumbnail']: "https://img.freepik.com/free-vector/elegant-musical-notes-music-chord-background_1017-20759.jpg",
        file: json['fichier'],
        country: isNotNull(json['country'])? json['country'] : "",
        rythme:  json['categorie']['libelle'],
        author:  isNotNull(json['blazartiste']) ? json['blazartiste'] : "",
        yearofproduction: isNotNull(json['yearofproduction']) ? json['yearofproduction'] : ""
      );
}
