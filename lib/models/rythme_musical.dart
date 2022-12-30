class RythmeMusical {
  late String libelle;
  late int id;

  RythmeMusical({required this.id, required this.libelle});

    
 factory RythmeMusical.fromJson(Map<String, dynamic> json) {
    if (json == null) return RythmeMusical(id: 0, libelle: "");
    return RythmeMusical(id: json['id'], libelle: json['libelle']);
  }


  static List<RythmeMusical> fromJsonList(List list) {
    if (list == null) return [];
    return list.map((item) => RythmeMusical.fromJson(item)).toList();
  }

   String userAsString() {
    return '#${this.libelle}';
  }
}
