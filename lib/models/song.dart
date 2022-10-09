class Song {
  final String title, description, url, coverUrl, author, category;

  Song(
      {required this.title,
      required this.description,
      required this.url,
      required this.coverUrl,
      required this.author,
      required this.category});

  static List<Song> songs = [
    Song(
        title: "Yinton Nan Gbonvo",
        description: "description",
        url: "https://toutbaigne.com/?wpdmdl=9699/GBONVO",
        coverUrl: "https://toutbaigne.com/wp-content/uploads/2019/10/Dibi-Dobo-Yinton-Nan-Gbonvo.jpg",
        author: "Dibi Dobo",
        category: "Afro-Pop"),
    Song(
        title: "Prière du matin",
        description: "description",
        url: "https://toutbaigne.com/?wpdmdl=9770/PRIERE",
        coverUrl: "https://toutbaigne.com/wp-content/uploads/2019/12/Syam-Fofo-Prière-du-matin.jpg",
        author: "Syam Fofo",
        category: "Gospel"),
        
    Song(
        title: "Fènou",
        description: "description",
        url: "https://toutbaigne.com/?wpdmdl=9235/FENOU",
        coverUrl: "https://toutbaigne.com/wp-content/uploads/2019/11/Prophétie-Fènou.jpg",
        author: "Prophétie",
        category: "Tôba"),
    Song(
        title: "C’est Show",
        description: "description",
        url: "https://toutbaigne.com/?wpdmdl=9614/CESTSHOW",
        coverUrl: "https://toutbaigne.com/wp-content/uploads/2019/12/Davila-Ft-Yesto-Charado-Cest-Show.jpg",
        author: "Davila Ft Yesto Charles",
        category: "Rap")
  ];
}
