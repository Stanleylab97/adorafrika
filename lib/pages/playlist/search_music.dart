import 'package:adorafrika/models/song.dart';
import 'package:adorafrika/pages/playlist/newMusics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Search extends StatefulWidget {
  List<Song>? songs;
  Search({super.key, this.songs});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    var songs = widget.songs;
    return Scaffold(
      appBar: AppBar(title: Text("Résultats trouvés"), centerTitle: true,),
        body: SingleChildScrollView(
            child: songs!.length<1 ?Padding(
              padding: const EdgeInsets.only(top: 350),
              child: Center(child: Text("Aucun résultat trouvé", style: TextStyle(color: Colors.red),),),
            ): ListView.builder(
               scrollDirection: Axis.vertical,
                shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        //  return Text("Toto", style: TextStyle(color:Colors.black),);
        final music = songs[index];
        if (music.typefile == "AUDIO")
          return AudioItem(
              size: MediaQuery.of(context).size,
              title: music.title!,
              blazartist: music.author!,
              country: music.country!,
              rythme: music.rythme!);
        else
          return GestureDetector(
            onTap: () {},
            child: VideoItem(music: music),
          );
      },
    )));
  }
}
