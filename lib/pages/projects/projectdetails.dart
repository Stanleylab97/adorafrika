import 'package:adorafrika/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;
  late final ScrollController scrollController;
  late final PanelController panelController;

  @override
  void initState() {
    scrollController = ScrollController();
    panelController = PanelController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = SizeConfig.screenHeight * .5;

    Widget _panel() {
      return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            physics: PanelScrollPhysics(controller: panelController),
            controller: scrollController,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * .037,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.001),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.brandsFontAwesome,
                                  color: SizeConfig.greenColor,
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * .02,
                                ),
                                Text(
                                  'Projet musical',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Concert géant d\'Angélique KIDJO',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Budget: 12.500.000 F CFA',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: SizeConfig.secondaryColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                          child: CachedNetworkImage(imageUrl:
                                              "https://images.pexels.com/photos/697509/pexels-photo-697509.jpeg?auto=compress&cs=tinysrgb&w=1200", fit: BoxFit.cover, height: 60, width: 60,)),
                                      SizedBox(
                                        width: SizeConfig.screenWidth * .02,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("COSSI Paul",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ],
                                      )
                                    ],
                                  ),
                                  onLongPress: (() {
                                    print("printed");
                                  }),
                                ),
                                GFButton(
                                  elevation: 10,
                                  onPressed: () {
                                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(/* chatParams: ChatParams(userUid, peer), */)));
                                  },
                                  text: "Télécharger",
                                  icon: Icon(FontAwesomeIcons.fileArrowDown,
                                      color: Colors.white),
                                  shape: GFButtonShape.pills,
                                ),
                                GFButton(
                                  elevation: 10,
                                  onPressed: () {
                                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(/* chatParams: ChatParams(userUid, peer), */)));
                                  },
                                  text: "Soutenir",
                                  icon: Icon(FontAwesomeIcons.phone,
                                      color: Colors.white),
                                  shape: GFButtonShape.pills,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${lorem(paragraphs: 1, words: 50)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          
                          color: Colors.grey.shade500
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ],
          ));
    }

    return Scaffold(
      body: SlidingUpPanel(
        snapPoint: .5,
        disableDraggableOnScrolling: false,
        header: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ForceDraggableWidget(
                child: Container(
                  width: 100,
                  height: 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 7,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        maxHeight: SizeConfig.screenHeight * .95,
        minHeight: SizeConfig.screenHeight * .5,
        parallaxEnabled: true,
        parallaxOffset: .5,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: SizeConfig.screenHeight * .5,
              width: SizeConfig.screenWidth,
              fit: BoxFit.cover,
              imageUrl:
                  "https://www.un.org/africarenewal/sites/www.un.org.africarenewal/files/kejo.jpg",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
        controller: panelController,
        scrollController: scrollController,
        panelBuilder: () => _panel(),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        onPanelSlide: (double pos) => setState(() {}),
      ),
    );
  }
}
