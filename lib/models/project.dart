class Project {
  final String title,
      type,
      photoUrl,
      author_firstname,
      author_surname,
      description,
      file_link,
      createdAt;
  final int? amount;

  Project(
      {required this.title,
      required this.type,
      required this.photoUrl,
      required this.author_firstname,
      required this.author_surname,
      required this.description,
      required this.file_link,
      required this.createdAt,
      this.amount});
}
