import 'dart:io';
import 'package:adorafrika/pages/navigator/navigation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PicknUploadPaneegyrique extends StatefulWidget {
  const PicknUploadPaneegyrique({super.key});

  @override
  State<PicknUploadPaneegyrique> createState() =>
      _PicknUploadPaneegyriqueState();
}

class _PicknUploadPaneegyriqueState extends State<PicknUploadPaneegyrique> {
  File? _video;
  VideoPlayerController? videoPlayerController;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _getVideo() async {
    XFile? video = await _imagePicker.pickVideo(source: ImageSource.gallery);
    _video = File(video!.path);
    videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
         setState(() {});
      });
      videoPlayerController!.play();
    

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => Navigation()));
              //Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            "Ajout de panégyrique",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              _video != null ? AspectRatio(aspectRatio: 16.0/9.0,
              child: videoPlayerController!.value.isInitialized? VideoPlayer(videoPlayerController!):Container(),
              ):AspectRatio(aspectRatio: 16.0/9.0,
              child: Container(child: Text("Veuillez choisir la vidéo"), color:Colors.grey,alignment: Alignment.center,),
              ),

              ElevatedButton(onPressed: _getVideo, child: Text('Choisissez la vidéo'))
            ],
          ),
        ),
    );
  }
}
