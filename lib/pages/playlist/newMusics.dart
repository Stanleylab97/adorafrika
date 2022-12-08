import 'dart:convert';
import 'package:adorafrika/pages/player.dart';
import 'package:http/http.dart' as http;
import 'package:adorafrika/models/song.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewMusics extends StatefulWidget {
  const NewMusics({super.key});

  @override
  State<NewMusics> createState() => _NewMusicsState();
}

class _NewMusicsState extends State<NewMusics> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String title = "";
    String blazartist = "";
    String country = "";
    String rythme = "";
    ScrollController scrollController = ScrollController();

    Future<List<Song>> geSongsList() async {
      try {
        // var client = new http.Client();

        var response =
            await http.get(Uri.parse(NetworkHandler.baseurl + "/musique"));
        var jsonData = json.decode(response.body);
        var jsonArray = jsonData['musiques'];
        //print(jsonArray);
        return jsonArray.map<Song>(Song.fromJson).toList();
      } catch (ex) {
        return List.empty();
      }
    }

    return SingleChildScrollView(
      child: FutureBuilder<List<Song>>(
          future: geSongsList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var musics = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                itemCount: musics.length,
                itemBuilder: (context, index) {
                  //  return Text("Toto", style: TextStyle(color:Colors.black),);
                  final music = musics[index];
                  if (music.typefile == "AUDIO")
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Player(cover: music.thumnail, title: music.title, linkAudio: music.file,)));
                      },
                      child: AudioItem(
                          size: size,
                          title: music.title!,
                          blazartist: music.author!,
                          country: music.country!,
                          rythme: music.rythme!),
                    );
                  else
                    return GestureDetector(
                      onTap: () {},
                      child: VideoItem(music: music),
                    );
                },
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(color: Colors.red));
            }
          }),
    );
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem({
    Key? key,
    required this.music,
  }) : super(key: key);

  final Song music;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .13,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            music.thumnail != ""
                ? Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.height * .12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(music.thumnail!))))
                : Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.height * .12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/images/panigeriques/play.jpg")))),
            Container(
              color: Color(0xFF30314D),
              width: MediaQuery.of(context).size.width * .61,
              height: MediaQuery.of(context).size.height * .12,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .01,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${music.title}",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * .02,
                      ),
                      Text(
                        "${music.author}",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * .02,
                      ),
                      Text("${music.country} -${music.rythme}",
                          style: TextStyle(fontSize: 16, color: Colors.white))
                    ],
                  )
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}

class AudioItem extends StatelessWidget {
  const AudioItem({
    Key? key,
    required this.size,
    required this.title,
    required this.blazartist,
    required this.country,
    required this.rythme,
  }) : super(key: key);

  final Size size;
  final String title;
  final String blazartist;
  final String country;
  final String rythme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: size.height * .002,
          left: size.width * .009,
          right: size.width * .009,
          bottom: size.width * .01),
      padding: EdgeInsets.only(
        top: size.height * .01,
        left: size.width * .025,
        right: size.width * .025,
        bottom: size.height * .01,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF30314D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            "1",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: size.width * .04),
          InkWell(
            onTap: () {},
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "$title - $blazartist",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    "$country - $rythme",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  )
                ],
              )
            ]),
          ),
          Spacer(),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Icon(
              Icons.play_arrow,
              size: 25,
              color: Color(0xFF31314F),
            ),
          )
        ],
      ),
    );
  }
}
