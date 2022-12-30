
import 'dart:async';
import 'dart:convert';

import 'package:adorafrika/customWidgets/custom_physics.dart';
import 'package:adorafrika/customWidgets/empty_screen.dart';
import 'package:adorafrika/models/song.dart';
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
  Future.delayed(Duration(seconds: 7), () async {
    const String authority = 'www.backend.adorafrika.com';
    const String topPath = '/api/musique';
    final String unencodedPath = topPath;

    final Response res = await get(Uri.https(authority, unencodedPath));
   
    if (res.statusCode != 200) return List.empty();
    final Map data = json.decode(res.body) as Map;
    print(data['traditionelle']);
    Hive.box('cache').put(type, data['traditionelle'] as List);
    return data['traditionelle'] as List;
  });
  return List.empty();
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
     getCachedData(widget.type);
    getData(widget.type);
    
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List showList = cachedrecents;
    final bool isListEmpty = emptyTop;
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            builder: (context, snapshot) {
              // WHILE THE CALL IS BEING MADE AKA LOADING
              if (ConnectionState.active != null && !snapshot.hasData) {
                return Center(
                    child: Text(
                  'Loading',
                  style: TextStyle(color: Colors.white),
                ));
              }

              // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
              if (ConnectionState.done != null && snapshot.hasError) {
                return Center(
                    child: Text(
                  "Error",
                  style: TextStyle(color: Colors.white),
                ));
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cachedrecents.length,
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
                          if (showList[index]['thumbnail'] != '' &&
                              showList[index]['thumbnail'] != null)
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width * .12,
                              height: MediaQuery.of(context).size.height * 1,
                              fit: BoxFit.cover,
                              imageUrl: showList[index]['thumbnail'].toString(),
                              errorWidget: (context, _, __) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/cover.jpg'),
                              ),
                              placeholder: (context, url) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/cover.jpg'),
                              ),
                            )
                          else
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width * .12,
                              height: MediaQuery.of(context).size.height * 1,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg",
                              errorWidget: (context, _, __) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/cover.jpg'),
                              ),
                              placeholder: (context, url) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/cover.jpg'),
                              ),
                            )
                        ],
                      ),
                    ),
                    title: Text(
                      '${index + 1}. ${showList[index]['titre'] == null ? AppLocalizations.of(context)!.unknown : showList[index]["titre"]}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      showList[index]['blazartiste'] == null
                          ? AppLocalizations.of(context)!.unknown
                          : showList[index]['blazartiste'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: setIcon(showList[index]['typefile']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(
                            query: showList[index]['titre'].toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            future: futurescrapData('traditionelle'),
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
