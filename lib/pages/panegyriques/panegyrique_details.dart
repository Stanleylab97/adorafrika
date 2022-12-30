import 'package:adorafrika/models/panegyrique.dart';
import 'package:adorafrika/pages/panegyriques/panegyric_video_player.dart';
import 'package:adorafrika/pages/panegyriques/panegyrique_audio_player.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class PanegyriqueDetails extends StatefulWidget {
  final Panegyrique panegyrique;
  const PanegyriqueDetails({super.key, required this.panegyrique});

  @override
  State<PanegyriqueDetails> createState() => _PanegyriqueDetailsState();
}

class _PanegyriqueDetailsState extends State<PanegyriqueDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              child: widget.panegyrique.thumbnail != null
                  ? CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * .12,
                      height: MediaQuery.of(context).size.height * 1,
                      fit: BoxFit.cover,
                      imageUrl: widget.panegyrique.thumbnail!,
                      errorWidget: (context, _, __) => const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/panigeriques/images.jpeg'),
                      ),
                      placeholder: (context, url) => const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/panigeriques/images.jpeg'),
                      ),
                    )
                  : Image.asset("assets/images/panigeriques/images.jpeg")),
          buttonArrow(context),
          scroll(),
        ],
      ),
    ));
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.family +
                            " " +
                            widget.panegyrique.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            Text(
                        AppLocalizations.of(context)!.play + "  ",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                            Icon(
                              Icons.play_circle_filled,
                              color: Colors.red,
                              size: 55,
                            ),
                          ],
                        ),
                        onTap: () {
                           Navigator.push(
                  context, MaterialPageRoute(builder: (context) => widget.panegyrique.type=="VIDEO" ?PanegyricVideoPlayer(fichier: widget.panegyrique.fichier):PanegyricAudioPlayer(songInfo: widget.panegyrique)));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileTap(showFollowBottomInProfile: true),
                                  )); */
                            },
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage("assets/images/auth/user.png"),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .02,
                          ),
                          Text(
                            'superadmin',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Type : ${widget.panegyrique.isPanegyric == 0 ? AppLocalizations.of(context)!.story : AppLocalizations.of(context)!.panegyric}",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.country + ":",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      Text(
                        widget.panegyrique.countryLibelle,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.green,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "2 Approbations",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.state + " :",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        widget.panegyrique.state,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.format + " ",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                        TextButton(
              child: Text(
                widget.panegyrique.type,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {},
              style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      elevation: 2,
                      backgroundColor: Colors.red),
            ),
                    ],
                  ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.region + " : ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            widget.panegyrique.region,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                 
                      
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage("assets/images/logo-AdorAfrika.png"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .02,
                        ),
                        Text(
                          'JadorAfrika',
                          style: GoogleFonts.fuzzyBubbles(
                              textStyle: TextStyle(
                                  color: SizeConfig.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                    

                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
