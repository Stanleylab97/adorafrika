import 'package:adorafrika/models/panegyrique.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';


class AdorAfrikaVideoPlayer extends StatefulWidget {
  final String fichier;
  const AdorAfrikaVideoPlayer({super.key, required this.fichier});

  @override
  State<AdorAfrikaVideoPlayer> createState() => _AdorAfrikaVideoPlayerState();
}

class _AdorAfrikaVideoPlayerState extends State<AdorAfrikaVideoPlayer> {
VideoPlayerController? videoPlayerController;
ChewieController? chewieController;

@override
  void initState() {
    super.initState();
    videoPlayerController=VideoPlayerController.network(widget.fichier);
    videoPlayerController!.initialize().then((_){
      chewieController=ChewieController(videoPlayerController: videoPlayerController!);
     setState(() {
             print('Video player\'s  good to go');
     });

    });
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  Widget _chewieVideoPlayer(){
    return chewieController != null && videoPlayerController!=null ? Container(child: Chewie(controller: chewieController!)): Center(child: Lottie.asset('assets/lottiefiles/video-process-loader.json'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              //Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        title: Text('JadorAfrika video player', style: TextStyle(color:Colors.green),),
      ),
      body: _chewieVideoPlayer(),
    );
  }
}
