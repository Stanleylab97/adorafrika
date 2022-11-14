class CategoryMusic {
  final String id;
  final String libelle;
  final String description;

  CategoryMusic({required this.id, required this.libelle, required this.description});

  factory CategoryMusic.fromJson(Map<String, dynamic> json) {
    if (json == null) return CategoryMusic(id: "0", libelle: "", description: "");
    return CategoryMusic(
      id: json["id"].toString(),
     /*  createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]), */
      libelle: json["libelle"],
      description: json["description"],
    );
  }

  static List<CategoryMusic> fromJsonList(List list) {
    if (list == null) return [];
    return list.map((item) => CategoryMusic.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.libelle}';
  }



  ///custom comparing function to check if two users are equal
  bool isEqual(CategoryMusic model) {
    return this.id == model.id;
  }

  @override
  String toString() => libelle;
}