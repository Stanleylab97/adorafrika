/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2022, Ankit Sangwan
 */

import 'dart:convert';

import 'package:adorafrika/customWidgets/custom_physics.dart';
import 'package:adorafrika/customWidgets/empty_screen.dart';
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

List topSongs = [];
List viralSongs = [];
List cachedTopSongs = [];
List cachedViralSongs = [];
bool fetched = false;
bool emptyTop = false;
bool emptyViral = false;

class Recents extends StatefulWidget {
  const Recents({
    super.key,
  });

  @override
  _RecentsState createState() => _RecentsState();
}

class _RecentsState extends State<Recents>
    with AutomaticKeepAliveClientMixin<Recents> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext cntxt) {
    super.build(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener(
        onNotification: (overscroll) {
          if (overscroll is OverscrollNotification &&
              overscroll.overscroll != 0 &&
              overscroll.dragDetails != null) {}
          return true;
        },
        child: const TabBarView(
          physics: CustomPhysics(),
          children: [
            TopPage(type: 'top'),
          ],
        ),
      ),
    );
  }
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
  print(data['musiques']);
  return data['musiques'] as List;
}

class TopPage extends StatefulWidget {
  final String type;
  const TopPage({super.key, required this.type});
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage>
    with AutomaticKeepAliveClientMixin<TopPage> {
  Future<void> getData(String type) async {
    fetched = true;
    final List temp = await compute(scrapData, type);
    setState(() {
      topSongs = temp;
      if (topSongs.isNotEmpty) {
        cachedTopSongs = topSongs;
        Hive.box('cache').put(type, topSongs);
      }
      emptyTop = topSongs.isEmpty && cachedTopSongs.isEmpty;
    });
  }

  Future<void> getCachedData(String type) async {
    fetched = true;

    cachedTopSongs =
        await Hive.box('cache').get(type, defaultValue: []) as List;

    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'top' && topSongs.isEmpty) {
        getCachedData(widget.type);
      getData(widget.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!fetched) {
       getCachedData(widget.type);
      getData(widget.type);
    }
    final List showList = cachedTopSongs;
    final bool isListEmpty = emptyTop;
    return Column(
      children: [
        if (showList.length <= 2)
          Expanded(
            child: isListEmpty
                ? emptyScreen(
                    context,
                    0,
                    ':( ',
                    100,
                    'ERROR',
                    60,
                    'Service Unavailable',
                    20,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  ),
          )
        else
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: showList.length,
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
                        if (showList[index]['thumbnail'] != '')
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
                          ),
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
       return Icon(FontAwesomeIcons.video,size: 17);
    default:
     return Icon(FontAwesomeIcons.linkSlash,size: 17);
  }
}
