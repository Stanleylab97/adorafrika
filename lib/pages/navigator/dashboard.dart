import 'package:adorafrika/models/song.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  const Dashboard(
      {Key? key, required this.showNavigation, required this.hideNavigation})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.songs;
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const _CustomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Explorez la culture sous ses  différentes coutures",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * .03),
                  TextFormField(
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Recherche ...",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade400),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none)),
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Musiques tendances',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('Voir plus'),
                        ],
                      ),
                      SizedBox(
                        height: size.height * .21,
                        child: ListView.builder(
                            itemCount: songs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  Get.toNamed("/player",
                                      arguments: songs[index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        width: size.width * .4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  songs[index].coverUrl),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Container(
                                        height: size.height * .05,
                                        width: size.width * .37,
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color:
                                                Colors.white.withOpacity(0.8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  songs[index].title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.5,
                                                          color: Colors
                                                              .deepPurple),
                                                ),
                                                Text(
                                                  songs[index].category,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .deepPurple),
                                                ),
                                              ],
                                            ),
                                            Icon(Icons.play_circle,
                                                color: Colors.deepPurple),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nouveaux projets',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text('Voir plus'),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .42,
                    child: ListView.builder(
                        itemCount: songs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return InkWell(
                              onTap: () {
                                Get.toNamed("/projectDetails",
                                    arguments: songs[index]);
                              },
                              child: Card(
                                  elevation: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    width: size.width * .7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://images.pexels.com/photos/428333/pexels-photo-428333.jpeg?auto=compress&cs=tinysrgb&w=1200",
                                                      fit: BoxFit.cover,
                                                      height: size.height * .07,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * .03,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "GANGBADJA",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Text("Maurille",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          12))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "https://www.arras.fr/sites/default/files/styles/page_teaser/public/images_de_test_a_supprimer/ok201611_0314_projetculturel_couv-1.jpg?itok=ZSWS3bXs",
                                                height: size.height * .17,
                                                width: size.width * .7,
                                              ),
                                              SizedBox(
                                                  height: size.height * .01),
                                            ],
                                          ),
                                          Text(
                                            "La description du projet est une déclaration écrite formelle du projet, de son idée et de son contexte, qui explique les buts et les objectifs à atteindre, le besoin commercial et le problème à résoudre, les pièges et les défis potentiels, les approches et les méthodes d'exécution, les estimations des ressources",
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 12),
                                            maxLines: 5,
                                          ),
                                          SizedBox(height: size.height * .022),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.eye,
                                                    color: Colors.green,
                                                    size: 24,
                                                  ),
                                                  SizedBox(
                                                    width: size.width * .01,
                                                  ),
                                                  Text("(103)",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 12))
                                                ],
                                              ),
                                              Icon(
                                                FontAwesomeIcons.fileArrowDown,
                                                color: Colors.green,
                                                size: 24,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )));
                        }),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class _CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),
      backgroundColor: Colors.transparent,
      actions: [
        Container(
            margin: EdgeInsets.only(right: 20),
            child: CircleAvatar(
                child: CachedNetworkImage(
              imageUrl:
                  "https://www.betterteam.com/images/musician-job-description-6000x4000-20201118.jpeg?crop=1:1,smart&width=1200&dpr=2",
              width: 30,
            )))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56.0);
}
