import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adorafrika/models/panegyrique.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';

class PanegyricAudioPlayer extends StatefulWidget {
  late Panegyrique songInfo;
  final GlobalKey<_PanegyricAudioPlayerState>? key;
  PanegyricAudioPlayer({required this.songInfo, this.key}) : super(key: key);

  @override
  State<PanegyricAudioPlayer> createState() => _PanegyricAudioPlayerState();
}

class _PanegyricAudioPlayerState extends State<PanegyricAudioPlayer> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    player.dispose();
  }

  void setSong(Panegyrique songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.fichier);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : Theme.of(context).colorScheme.secondary,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white)),
        title: Text('AdorAfrika Audio player',
            style: TextStyle(color: Colors.green)),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : Theme.of(context).colorScheme.secondary,
        margin: EdgeInsets.fromLTRB(5, 57, 5, 0),
        child: Column(children: <Widget>[
          widget.songInfo.thumbnail == null
              ? CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/panigeriques/images.jpeg'),
                  radius: 200)
              : CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.songInfo.thumbnail.toString()),
                  radius: 200,
                ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              AppLocalizations.of(context)!.family +
                            " " + widget.songInfo.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 33),
            child: Text(
              "@"+widget.songInfo.username,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Slider(
            inactiveColor: Colors.white,
            activeColor: Colors.yellow.shade600,
            min: minimumValue,
            max: maximumValue+100,
            value: currentValue,
            onChanged: (value) {
              currentValue = value;
              print("Max= $maximumValue == current=$currentValue");
              player.seek(Duration(milliseconds: currentValue.round()));
            },
          ),
          Container(
            transform: Matrix4.translationValues(0, -15, 0),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
                Text(endTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
/*  GestureDetector(child: Icon(Icons.skip_previous, color: Colors.black, size: 55), behavior: HitTestBehavior.translucent,onTap: () {
  widget.changeTrack(false);
 },), */
                GestureDetector(
                  child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: Colors.green,
                      size: 85),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    changeStatus();
                  },
                ),
                /*  GestureDetector(child: Icon(Icons.skip_next, color: Colors.black, size: 55), behavior: HitTestBehavior.translucent,onTap: () {
    widget.changeTrack(true);
 },), */
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
