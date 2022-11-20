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
        thumnail: isNotNull(json['thumbnail']) ?  json['thumbnail']: "",
        file: json['fichier'],
        country: isNotNull(json['country'])? json['country'] : "",
        rythme:  json['categories_id'].toString(),
        author:  isNotNull(json['blazartiste']) ? json['blazartiste'] : "",
        yearofproduction: isNotNull(json['yearofproduction']) ? json['yearofproduction'] : ""
      );
}
