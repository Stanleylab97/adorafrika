
import 'dart:async';
import 'dart:convert';

import 'package:adorafrika/customWidgets/custom_physics.dart';
import 'package:adorafrika/customWidgets/empty_screen.dart';
import 'package:adorafrika/models/song.dart';
import 'package:adorafrika/pages/musics/manager/song_list.dart';
import 'package:adorafrika/pages/panegyriques/panegyric_video_player.dart';
import 'package:adorafrika/pages/playlist/Search/search.dart';

// import 'package:blackhole/Helpers/countrycodes.dart';

// import 'package:blackhole/Screens/Settings/setting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:html_unescape/html_unescape_small.dart';
import 'package:http/http.dart';

List recents = [];
List cachedrecents = [];
bool fetched = false;
bool emptyTop = false;

class Traditionals extends StatefulWidget {
  const Traditionals({
    super.key,
  });

  @override
  _TraditionalsState createState() => _TraditionalsState();
}

class _TraditionalsState extends State<Traditionals>
    with AutomaticKeepAliveClientMixin<Traditionals> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext cntxt) {
    super.build(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TopPage(type: 'traditionelle'),
    );
  }
}

Future<List> futurescrapData(String type) async {
  return Future.delayed(Duration(seconds: 7), () async {
    const String authority = 'www.backend.adorafrika.com';
    const String topPath = '/api/musique';
    final String unencodedPath = topPath;

    final Response res = await get(Uri.https(authority, unencodedPath));
   
    if (res.statusCode != 200) return List.empty();
    final Map data = json.decode(res.body) as Map;
    print(data['traditionelle']);
  
    return data['traditionelle'] as List;
  });
}

 Future<List> scrapData(String type) async {
  const String authority = 'www.backend.adorafrika.com';
  const String topPath = '/api/musique';

  final String unencodedPath = topPath;
  // if (isWeekly) unencodedPath += weeklyPath;

  final Response res = await get(Uri.https(authority, unencodedPath));

  if (res.statusCode != 200) return List.empty();
  /*  final result = RegExp(r'<script.*>({\"context\".*})<\/script>', dotAll: true)
      .firstMatch(res.body); */
  final Map data = json.decode(res.body) as Map;
  return data['traditionelle'] as List;
}


class TopPage extends StatefulWidget {
  final String type;
  const TopPage({super.key, required this.type});
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage>
    with AutomaticKeepAliveClientMixin<TopPage> {
  List temp = List.empty();

  Future<void> getCachedData(String type) async {
    fetched = true;

    cachedrecents = await Hive.box('cache').get(type, defaultValue: []) as List;

    setState(() {});
  }

   Future<void> getData(String type) async {
    fetched = true;
    final List temp = await compute(scrapData, type);
    setState(() {
      recents = temp;
      if (recents.isNotEmpty) {
        cachedrecents = recents;
        Hive.box('cache').put(type, recents);
      }
      emptyTop = recents.isEmpty && cachedrecents.isEmpty;
    });
  }

 
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isListEmpty = emptyTop;
    return Column(
      children: [
        Expanded(
          child:  FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Error",
                    style: TextStyle(color: Colors.white),
                  ));

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemExtent: 70.0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              const Image(
                                image: AssetImage('assets/images/cover.jpg'),
                              ),
                              if (snapshot.data[index]['thumbnail'] != '' &&
                                  snapshot.data[index]['thumbnail'] != null)
                                CachedNetworkImage(
                                  width:
                                      MediaQuery.of(context).size.width * .12,
                                  height:
                                      MediaQuery.of(context).size.height * 1,
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data[index]['thumbnail']
                                      .toString(),
                                  errorWidget: (context, _, __) => const Image(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/cover.jpg'),
                                  ),
                                  placeholder: (context, url) => const Image(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/cover.jpg'),
                                  ),
                                )
                              else
                                CachedNetworkImage(
                                  width:
                                      MediaQuery.of(context).size.width * .12,
                                  height:
                                      MediaQuery.of(context).size.height * 1,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg",
                                  errorWidget: (context, _, __) => const Image(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/cover.jpg'),
                                  ),
                                  placeholder: (context, url) => const Image(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/cover.jpg'),
                                  ),
                                )
                            ],
                          ),
                        ),
                        title: Text(
                          '${index + 1}. ${snapshot.data[index]['titre'] == null ? AppLocalizations.of(context)!.unknown : snapshot.data[index]["titre"]}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          snapshot.data[index]['blazartiste'] == null
                              ? AppLocalizations.of(context)!.unknown
                              : snapshot.data[index]['blazartiste'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: setIcon(snapshot.data[index]['typefile']),
                        onTap: () {
                          snapshot.data[index]['typefile']=="AUDIO"?
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  SongsListPage(
                                                                        listItem:
                                                                            snapshot.data[index]
                                                                                as Map,
                                                                      ),
                            ),
                          ):Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdorAfrikaVideoPlayer(
                                 fichier: snapshot.data[index]['fichier'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }else{
                  return Center(
                      child: Text(
                    "Booooom",
                    style: TextStyle(color: Colors.white),
                  ));
                }
              }
          
                return Center(
                  child: CircularProgressIndicator(),
                );
         
            },
            future: futurescrapData('gospels'),
          ),
      ),
      ],
    );
  }
}

Icon setIcon(type) {
  switch (type) {
    case "AUDIO":
      return Icon(FontAwesomeIcons.music, size: 17);

    case "VIDEO":
      return Icon(FontAwesomeIcons.video, size: 17);
    default:
      return Icon(FontAwesomeIcons.linkSlash, size: 17);
  }
}
