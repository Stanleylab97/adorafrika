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

import 'dart:developer';

import 'package:adorafrika/customWidgets/add_playlist.dart';
import 'package:adorafrika/customWidgets/custom_physics.dart';
import 'package:adorafrika/customWidgets/data_search.dart';
import 'package:adorafrika/customWidgets/empty_screen.dart';
import 'package:adorafrika/customWidgets/gradient_containers.dart';
import 'package:adorafrika/customWidgets/miniplayer.dart';
import 'package:adorafrika/customWidgets/playlist_head.dart';
import 'package:adorafrika/customWidgets/snackbar.dart';
import 'package:adorafrika/helpers/audio_query.dart';
import 'package:adorafrika/pages/musics/recents.dart';
import 'package:adorafrika/pages/musics/religious.dart';
import 'package:adorafrika/pages/musics/traditionals.dart';
import 'package:adorafrika/pages/playlist/Player/audioplayer.dart';
import 'package:adorafrika/pages/playlist/add_musique.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

class MusicsDash extends StatefulWidget {
  final List<SongModel>? cachedSongs;
  final String? title;
  final int? playlistId;
  final bool showPlaylists;
  const MusicsDash({
    super.key,
    this.cachedSongs,
    this.title,
    this.playlistId,
    this.showPlaylists = false,
  });
  @override
  _MusicsDashState createState() => _MusicsDashState();
}

class _MusicsDashState extends State<MusicsDash> with TickerProviderStateMixin {
  List<SongModel> _songs = [];
  String? tempPath = Hive.box('settings').get('tempDirPath')?.toString();
  final Map<String, List<SongModel>> _albums = {};
  final Map<String, List<SongModel>> _artists = {};
  final Map<String, List<SongModel>> _genres = {};

  final List<String> _sortedAlbumKeysList = [];
  final List<String> _sortedArtistKeysList = [];
  final List<String> _sortedGenreKeysList = [];
  // final List<String> _videos = [];
  ScrollController scrollController = ScrollController();
  late SingleValueDropDownController _cnt;
  bool? searchBycountry = false;
  bool? searchByyearofproduction = false;
  bool? searchByblazartiste = false;
  String codepays = "";
  TextEditingController pays = TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  TextEditingController anneeprod = TextEditingController();
  TextEditingController blazArtist = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  bool isloading = false;
  late String search_key;

  bool added = false;
  int sortValue = Hive.box('settings').get('sortValue', defaultValue: 1) as int;
  int orderValue =
      Hive.box('settings').get('orderValue', defaultValue: 1) as int;
  int albumSortValue =
      Hive.box('settings').get('albumSortValue', defaultValue: 2) as int;
  List dirPaths =
      Hive.box('settings').get('searchPaths', defaultValue: []) as List;
  int minDuration =
      Hive.box('settings').get('minDuration', defaultValue: 10) as int;
  bool includeOrExclude =
      Hive.box('settings').get('includeOrExclude', defaultValue: false) as bool;
  List includedExcludedPaths = Hive.box('settings')
      .get('includedExcludedPaths', defaultValue: []) as List;
  TabController? _tcontroller;
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
  List<PlaylistModel> playlistDetails = [];

  @override
  void initState() {
    _tcontroller = TabController(length: 3, vsync: this);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tcontroller!.dispose();
  }

  bool checkIncludedOrExcluded(SongModel song) {
    for (final path in includedExcludedPaths) {
      if (song.data.contains(path.toString())) return true;
    }
    return false;
  }

  Future<void> getData() async {
    await offlineAudioQuery.requestPermission();
    tempPath ??= (await getTemporaryDirectory()).path;
    playlistDetails = await offlineAudioQuery.getPlaylists();
    if (widget.cachedSongs == null) {
      _songs = (await offlineAudioQuery.getSongs(
              /*  sortType: songSortTypes[sortValue],
        orderType: songOrderTypes[orderValue], */
              ))
          .where(
            (i) =>
                (i.duration ?? 60000) > 1000 * minDuration &&
                (i.isMusic! || i.isPodcast! || i.isAudioBook!) &&
                (includeOrExclude
                    ? checkIncludedOrExcluded(i)
                    : !checkIncludedOrExcluded(i)),
          )
          .toList();
    } else {
      _songs = widget.cachedSongs!;
    }
    added = true;
    setState(() {});
    for (int i = 0; i < _songs.length; i++) {
      try {
        if (_albums.containsKey(_songs[i].album ?? 'Unknown')) {
          _albums[_songs[i].album ?? 'Unknown']!.add(_songs[i]);
        } else {
          _albums[_songs[i].album ?? 'Unknown'] = [_songs[i]];
          _sortedAlbumKeysList.add(_songs[i].album ?? 'Unknown');
        }

        if (_artists.containsKey(_songs[i].artist ?? 'Unknown')) {
          _artists[_songs[i].artist ?? 'Unknown']!.add(_songs[i]);
        } else {
          _artists[_songs[i].artist ?? 'Unknown'] = [_songs[i]];
          _sortedArtistKeysList.add(_songs[i].artist ?? 'Unknown');
        }

        if (_genres.containsKey(_songs[i].genre ?? 'Unknown')) {
          _genres[_songs[i].genre ?? 'Unknown']!.add(_songs[i]);
        } else {
          _genres[_songs[i].genre ?? 'Unknown'] = [_songs[i]];
          _sortedGenreKeysList.add(_songs[i].genre ?? 'Unknown');
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  search() async {
    setState(() {
      isloading = true;
    });
  }

  showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recherche',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      onPressed: () {
                        searchByblazartiste =
                            searchBycountry = searchByyearofproduction = false;
                        anneeprod.clear();
                        blazArtist.clear();
                        codepays = "";
                        Navigator.pop(context);
                      },
                      minWidth: 40,
                      height: 40,
                      color: Colors.grey.shade300,
                      elevation: 0,
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: this.searchBycountry,
                            onChanged: (val) => setState(() {
                              this.searchBycountry = val!;
                            }),
                          ),
                          title: !searchBycountry!
                              ? Text(
                                  "Rechercher par pays",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                )
                              : Center(
                                  child: codepays.isEmpty
                                      ? FloatingActionButton.extended(
                                          heroTag: "searchBy-country",
                                          elevation: 8,
                                          label: Center(
                                              child: Text(
                                            'Choisissez le pays',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                          backgroundColor: Colors.white,
                                          icon: Icon(
                                            FontAwesomeIcons.flag,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            final code = await countryPicker
                                                .showPicker(context: context);
                                            if (code != null) {
                                              setState(() {
                                                pays.text = code.name;
                                                codepays = code.code;
                                                search_key = pays.text;
                                              });
                                            }
                                          },
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            final code = await countryPicker
                                                .showPicker(context: context);
                                            if (code != null) {
                                              setState(() {
                                                pays.text = code.name;
                                                codepays = code.code;
                                              });
                                            }
                                          },
                                          child: TextFormField(
                                            controller: pays,
                                            enabled: false,
                                            style:
                                                TextStyle(color: Colors.black),
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText: "Pays sélectionné"),
                                          ),
                                        ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: this.searchByyearofproduction,
                            onChanged: (val) => setState(() {
                              this.searchByyearofproduction = val!;
                            }),
                          ),
                          title: Center(
                            child: TextFormField(
                              controller: anneeprod,
                              onChanged: (value) {
                                search_key = value;
                              },
                              enabled:
                                  this.searchByyearofproduction! ? true : false,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Année de production"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: this.searchByblazartiste,
                            onChanged: (val) => setState(() {
                              this.searchByblazartiste = val!;
                            }),
                          ),
                          title: Center(
                            child: TextFormField(
                              onChanged: (value) {
                                search_key = value;
                              },
                              controller: blazArtist,
                              enabled: searchByblazartiste! ? true : false,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Nom de l'artiste"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                isloading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.red))
                    : button('Search', () {
                        search();
                      })
              ],
            ),
          );
        });
      },
    );
  }

  button(String text, Function onPressed) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 50,
      elevation: 0,
      splashColor: Colors.yellow[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.red,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading: Text(''),
                  title: Text(
                    "AdorAfrika",
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    controller: _tcontroller,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        text: AppLocalizations.of(context)!.recents,
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.traditionals,
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.religious,
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.search),
                      tooltip: AppLocalizations.of(context)!.search,
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: DataSearch(
                            data: _songs,
                            tempPath: tempPath!,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.sort_down),
                      tooltip: AppLocalizations.of(context)!.search,
                      onPressed: () {
                        showFilterModal();
                      },
                    )
                  ],
                  centerTitle: true,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.secondary,
                  elevation: 0,
                ),
                body: !added
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TabBarView(
                        physics: const CustomPhysics(),
                        controller: _tcontroller,
                        children: [
                          const Recents(),
                          const Traditionals(),
                          const Religious()
                        ],
                      ),

                      floatingActionButton: FloatingActionButton(
                        heroTag: "create-music",
              backgroundColor: Colors.yellow.shade600,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddMusic()));
              },
              child: Icon(Icons.add))
              ),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }

//   Widget videosTab() {
//     return _cachedVideos.isEmpty
//         ? EmptyScreen().emptyScreen(context, 3, 'Nothing to ', 15.0,
//             'Show Here', 45, 'Download Something', 23.0)
//         : ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.only(top: 20, bottom: 10),
//             shrinkWrap: true,
//             itemExtent: 70.0,
//             itemCount: _cachedVideos.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(7.0),
//                   ),
//                   clipBehavior: Clip.antiAlias,
//                   child: Stack(
//                     children: [
//                       const Image(
//                         image: AssetImage('assets/images/cover.jpg'),
//                       ),
//                       if (_cachedVideos[index]['image'] == null)
//                         const SizedBox()
//                       else
//                         SizedBox(
//                           height: 50.0,
//                           width: 50.0,
//                           child: Image(
//                             fit: BoxFit.cover,
//                             image: MemoryImage(
//                                 _cachedVideos[index]['image'] as Uint8List),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 title: Text(
//                   '${_cachedVideos[index]['id'].split('/').last}',
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//                 trailing: PopupMenuButton(
//                   icon: const Icon(Icons.more_vert_rounded),
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(15.0))),
//                   onSelected: (dynamic value) async {
//                     if (value == 0) {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           final String fileName = _cachedVideos[index]['id']
//                               .split('/')
//                               .last
//                               .toString();
//                           final List temp = fileName.split('.');
//                           temp.removeLast();
//                           final String videoName = temp.join('.');
//                           final controller =
//                               TextEditingController(text: videoName);
//                           return AlertDialog(
//                             content: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Name',
//                                       style: TextStyle(
//                                           color: Theme.of(context).accentColor),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 TextField(
//                                     autofocus: true,
//                                     controller: controller,
//                                     onSubmitted: (value) async {
//                                       try {
//                                         Navigator.pop(context);
//                                         String newName = _cachedVideos[index]
//                                                 ['id']
//                                             .toString()
//                                             .replaceFirst(videoName, value);

//                                         while (await File(newName).exists()) {
//                                           newName = newName.replaceFirst(
//                                               value, '$value (1)');
//                                         }

//                                         File(_cachedVideos[index]['id']
//                                                 .toString())
//                                             .rename(newName);
//                                         _cachedVideos[index]['id'] = newName;
//                                         ShowSnackBar().showSnackBar(
//                                           context,
//                                           'Renamed to ${_cachedVideos[index]['id'].split('/').last}',
//                                         );
//                                       } catch (e) {
//                                         ShowSnackBar().showSnackBar(
//                                           context,
//                                           'Failed to Rename ${_cachedVideos[index]['id'].split('/').last}',
//                                         );
//                                       }
//                                       setState(() {});
//                                     }),
//                               ],
//                             ),
//                             actions: [
//                               TextButton(
//                                 style: TextButton.styleFrom(
//                                   primary: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? Colors.white
//                                       : Colors.grey[700],
//                                   //       backgroundColor: Theme.of(context).accentColor,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text(
//                                   'Cancel',
//                                 ),
//                               ),
//                               TextButton(
//                                 style: TextButton.styleFrom(
//                                   primary: Colors.white,
//                                   backgroundColor:
//                                       Theme.of(context).accentColor,
//                                 ),
//                                 onPressed: () async {
//                                   try {
//                                     Navigator.pop(context);
//                                     String newName = _cachedVideos[index]['id']
//                                         .toString()
//                                         .replaceFirst(
//                                             videoName, controller.text);

//                                     while (await File(newName).exists()) {
//                                       newName = newName.replaceFirst(
//                                           controller.text,
//                                           '${controller.text} (1)');
//                                     }

//                                     File(_cachedVideos[index]['id'].toString())
//                                         .rename(newName);
//                                     _cachedVideos[index]['id'] = newName;
//                                     ShowSnackBar().showSnackBar(
//                                       context,
//                                       'Renamed to ${_cachedVideos[index]['id'].split('/').last}',
//                                     );
//                                   } catch (e) {
//                                     ShowSnackBar().showSnackBar(
//                                       context,
//                                       'Failed to Rename ${_cachedVideos[index]['id'].split('/').last}',
//                                     );
//                                   }
//                                   setState(() {});
//                                 },
//                                 child: const Text(
//                                   'Ok',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                     if (value == 1) {
//                       try {
//                         File(_cachedVideos[index]['id'].toString()).delete();
//                         ShowSnackBar().showSnackBar(
//                           context,
//                           'Deleted ${_cachedVideos[index]['id'].split('/').last}',
//                         );
//                         _cachedVideos.remove(_cachedVideos[index]);
//                       } catch (e) {
//                         ShowSnackBar().showSnackBar(
//                           context,
//                           'Failed to delete ${_cachedVideos[index]['id']}',
//                         );
//                       }
//                       setState(() {});
//                     }
//                   },
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       value: 0,
//                       child: Row(
//                         children: const [
//                           Icon(Icons.edit_rounded),
//                           const SizedBox(width: 10.0),
//                           Text('Rename'),
//                         ],
//                       ),
//                     ),
//                     PopupMenuItem(
//                       value: 1,
//                       child: Row(
//                         children: const [
//                           Icon(Icons.delete_rounded),
//                           const SizedBox(width: 10.0),
//                           Text('Delete'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   Navigator.of(context).push(
//                     PageRouteBuilder(
//                       opaque: false, // set to false
//                       pageBuilder: (_, __, ___) => PlayScreen(
//                         data: {
//                           'response': _cachedVideos,
//                           'index': index,
//                           'offline': true
//                         },
//                         fromMiniplayer: false,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             });
//   }
}

class SongsTab extends StatefulWidget {
  final List<SongModel> songs;
  final int? playlistId;
  final String? playlistName;
  final String tempPath;
  const SongsTab({
    super.key,
    required this.songs,
    required this.tempPath,
    this.playlistId,
    this.playlistName,
  });

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.songs.isEmpty
        ? emptyScreen(
            context,
            3,
            AppLocalizations.of(context)!.nothingTo,
            15.0,
            AppLocalizations.of(context)!.showHere,
            45,
            AppLocalizations.of(context)!.downloadSomething,
            23.0,
          )
        : Column(
            children: [
              PlaylistHead(
                songsList: widget.songs,
                offline: true,
                fromDownloads: false,
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  itemExtent: 70.0,
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: OfflineAudioQuery.offlineArtworkWidget(
                        id: widget.songs[index].id,
                        type: ArtworkType.AUDIO,
                        tempPath: widget.tempPath,
                        fileName: widget.songs[index].displayNameWOExt,
                      ),
                      title: Text(
                        widget.songs[index].title.trim() != ''
                            ? widget.songs[index].title
                            : widget.songs[index].displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${widget.songs[index].artist?.replaceAll('<unknown>', 'Unknown') ?? AppLocalizations.of(context)!.unknown} - ${widget.songs[index].album?.replaceAll('<unknown>', 'Unknown') ?? AppLocalizations.of(context)!.unknown}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        onSelected: (int? value) async {
                          if (value == 0) {
                            AddToOffPlaylist().addToOffPlaylist(
                              context,
                              widget.songs[index].id,
                            );
                          }
                          if (value == 1) {
                            await OfflineAudioQuery().removeFromPlaylist(
                              playlistId: widget.playlistId!,
                              audioId: widget.songs[index].id,
                            );
                            ShowSnackBar().showSnackBar(
                              context,
                              '${AppLocalizations.of(context)!.removedFrom} ${widget.playlistName}',
                            );
                          }
                          // if (value == 0) {
                          // showDialog(
                          // context: context,
                          // builder: (BuildContext context) {
                          // final String fileName = _cachedSongs[index].uri!;
                          // final List temp = fileName.split('.');
                          // temp.removeLast();
                          //           final String songName = temp.join('.');
                          //           final controller =
                          //               TextEditingController(text: songName);
                          //           return AlertDialog(
                          //             content: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 Row(
                          //                   children: [
                          //                     Text(
                          //                       'Name',
                          //                       style: TextStyle(
                          //                           color: Theme.of(context).accentColor),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 const SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 TextField(
                          //                     autofocus: true,
                          //                     controller: controller,
                          //                     onSubmitted: (value) async {
                          //                       try {
                          //                         Navigator.pop(context);
                          //                         String newName = _cachedSongs[index]
                          //                                 ['id']
                          //                             .toString()
                          //                             .replaceFirst(songName, value);

                          //                         while (await File(newName).exists()) {
                          //                           newName = newName.replaceFirst(
                          //                               value, '$value (1)');
                          //                         }

                          //                         File(_cachedSongs[index]['id']
                          //                                 .toString())
                          //                             .rename(newName);
                          //                         _cachedSongs[index]['id'] = newName;
                          //                         ShowSnackBar().showSnackBar(
                          //                           context,
                          //                           'Renamed to ${_cachedSongs[index]['id'].split('/').last}',
                          //                         );
                          //                       } catch (e) {
                          //                         ShowSnackBar().showSnackBar(
                          //                           context,
                          //                           'Failed to Rename ${_cachedSongs[index]['id'].split('/').last}',
                          //                         );
                          //                       }
                          //                       setState(() {});
                          //                     }),
                          //               ],
                          //             ),
                          //             actions: [
                          //               TextButton(
                          //                 style: TextButton.styleFrom(
                          //                   primary: Theme.of(context).brightness ==
                          //                           Brightness.dark
                          //                       ? Colors.white
                          //                       : Colors.grey[700],
                          //                   //       backgroundColor: Theme.of(context).accentColor,
                          //                 ),
                          //                 onPressed: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //                 child: const Text(
                          //                   'Cancel',
                          //                 ),
                          //               ),
                          //               TextButton(
                          //                 style: TextButton.styleFrom(
                          //                   primary: Colors.white,
                          //                   backgroundColor:
                          //                       Theme.of(context).accentColor,
                          //                 ),
                          //                 onPressed: () async {
                          //                   try {
                          //                     Navigator.pop(context);
                          //                     String newName = _cachedSongs[index]['id']
                          //                         .toString()
                          //                         .replaceFirst(
                          //                             songName, controller.text);

                          //                     while (await File(newName).exists()) {
                          //                       newName = newName.replaceFirst(
                          //                           controller.text,
                          //                           '${controller.text} (1)');
                          //                     }

                          //                     File(_cachedSongs[index]['id'].toString())
                          //                         .rename(newName);
                          //                     _cachedSongs[index]['id'] = newName;
                          //                     ShowSnackBar().showSnackBar(
                          //                       context,
                          //                       'Renamed to ${_cachedSongs[index]['id'].split('/').last}',
                          //                     );
                          //                   } catch (e) {
                          //                     ShowSnackBar().showSnackBar(
                          //                       context,
                          //                       'Failed to Rename ${_cachedSongs[index]['id'].split('/').last}',
                          //                     );
                          //                   }
                          //                   setState(() {});
                          //                 },
                          //                 child: const Text(
                          //                   'Ok',
                          //                   style: TextStyle(color: Colors.white),
                          //                 ),
                          //               ),
                          //               const SizedBox(
                          //                 width: 5,
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     }
                          //     if (value == 1) {
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           Uint8List? _imageByte =
                          //               _cachedSongs[index]['image'] as Uint8List?;
                          //           String _imagePath = '';
                          //           final _titlecontroller = TextEditingController(
                          //               text: _cachedSongs[index]['title'].toString());
                          //           final _albumcontroller = TextEditingController(
                          //               text: _cachedSongs[index]['album'].toString());
                          //           final _artistcontroller = TextEditingController(
                          //               text: _cachedSongs[index]['artist'].toString());
                          //           final _albumArtistController = TextEditingController(
                          //               text: _cachedSongs[index]['albumArtist']
                          //                   .toString());
                          //           final _genrecontroller = TextEditingController(
                          //               text: _cachedSongs[index]['genre'].toString());
                          //           final _yearcontroller = TextEditingController(
                          //               text: _cachedSongs[index]['year'].toString());
                          //           final tagger = Audiotagger();
                          //           return AlertDialog(
                          //             content: SizedBox(
                          //               height: 400,
                          //               width: 300,
                          //               child: SingleChildScrollView(
                          //                 physics: const BouncingScrollPhysics(),
                          //                 child: Column(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     GestureDetector(
                          //                       onTap: () async {
                          //                         final String filePath = await Picker()
                          //                             .selectFile(
                          //                                 context,
                          //                                 ['png', 'jpg', 'jpeg'],
                          //                                 'Pick Image');
                          //                         if (filePath != '') {
                          //                           _imagePath = filePath;
                          //                           final Uri myUri = Uri.parse(filePath);
                          //                           final Uint8List imageBytes =
                          //                               await File.fromUri(myUri)
                          //                                   .readAsBytes();
                          //                           _imageByte = imageBytes;
                          //                           final Tag tag = Tag(
                          //                             artwork: _imagePath,
                          //                           );
                          //                           try {
                          //                             await [
                          //                               Permission.manageExternalStorage,
                          //                             ].request();
                          //                             await tagger.writeTags(
                          //                               path: _cachedSongs[index]['id']
                          //                                   .toString(),
                          //                               tag: tag,
                          //                             );
                          //                           } catch (e) {
                          //                             await tagger.writeTags(
                          //                               path: _cachedSongs[index]['id']
                          //                                   .toString(),
                          //                               tag: tag,
                          //                             );
                          //                           }
                          //                         }
                          //                       },
                          //                       child: Card(
                          //                         elevation: 5,
                          //                         shape: RoundedRectangleBorder(
                          //                           borderRadius:
                          //                               BorderRadius.circular(7.0),
                          //                         ),
                          //                         clipBehavior: Clip.antiAlias,
                          //                         child: SizedBox(
                          //                           height: MediaQuery.of(context)
                          //                                   .size
                          //                                   .width /
                          //                               2,
                          //                           width: MediaQuery.of(context)
                          //                                   .size
                          //                                   .width /
                          //                               2,
                          //                           child: _imageByte == null
                          //                               ? const Image(
                          //                                   fit: BoxFit.cover,
                          //                                   image: AssetImage(
                          //                                       'assets/images/cover.jpg'),
                          //                                 )
                          //                               : Image(
                          //                                   fit: BoxFit.cover,
                          //                                   image:
                          //                                       MemoryImage(_imageByte!)),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     const SizedBox(height: 20.0),
                          //                     Row(
                          //                       children: [
                          //                         Text(
                          //                           'Title',
                          //                           style: TextStyle(
                          //                               color: Theme.of(context)
                          //                                   .accentColor),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     TextField(
                          //                         autofocus: true,
                          //                         controller: _titlecontroller,
                          //                         onSubmitted: (value) {}),
                          //                     const SizedBox(
                          //                       height: 30,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         Text(
                          //                           'Artist',
                          //                           style: TextStyle(
                          //                               color: Theme.of(context)
                          //                                   .accentColor),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     TextField(
                          //                         autofocus: true,
                          //                         controller: _artistcontroller,
                          //                         onSubmitted: (value) {}),
                          //                     const SizedBox(
                          //                       height: 30,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         Text(
                          //                           'Album Artist',
                          //                           style: TextStyle(
                          //                               color: Theme.of(context)
                          //                                   .accentColor),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     TextField(
                          //                         autofocus: true,
                          //                         controller: _albumArtistController,
                          //                         onSubmitted: (value) {}),
                          //                     const SizedBox(
                          //                       height: 30,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         Text(
                          //                           'Album',
                          //                           style: TextStyle(
                          //                               color: Theme.of(context)
                          //                                   .accentColor),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     TextField(
                          //                         autofocus: true,
                          //                         controller: _albumcontroller,
                          //                         onSubmitted: (value) {}),
                          //                     const SizedBox(
                          //                       height: 30,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         Text(
                          //                           'Genre',
                          //                           style: TextStyle(
                          //                               color: Theme.of(context)
                          //                                   .accentColor),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     TextField(
                          //                         autofocus: true,
                          //                         controller: _genrecontroller,
                          //                         onSubmitted: (value) {}),
                          //                     const SizedBox(
                          //                       height: 30,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         Text(
                          //                           'Year',
                          //                           style: TextStyle(
                          //                               color: Theme.of(context)
                          //                                   .accentColor),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     TextField(
                          //                         autofocus: true,
                          //                         controller: _yearcontroller,
                          //                         onSubmitted: (value) {}),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //             actions: [
                          //               TextButton(
                          //                 style: TextButton.styleFrom(
                          //                   primary: Theme.of(context).brightness ==
                          //                           Brightness.dark
                          //                       ? Colors.white
                          //                       : Colors.grey[700],
                          //                 ),
                          //                 onPressed: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //                 child: const Text('Cancel'),
                          //               ),
                          //               TextButton(
                          //                 style: TextButton.styleFrom(
                          //                   primary: Colors.white,
                          //                   backgroundColor:
                          //                       Theme.of(context).accentColor,
                          //                 ),
                          //                 onPressed: () async {
                          //                   Navigator.pop(context);
                          //                   _cachedSongs[index]['title'] =
                          //                       _titlecontroller.text;
                          //                   _cachedSongs[index]['album'] =
                          //                       _albumcontroller.text;
                          //                   _cachedSongs[index]['artist'] =
                          //                       _artistcontroller.text;
                          //                   _cachedSongs[index]['albumArtist'] =
                          //                       _albumArtistController.text;
                          //                   _cachedSongs[index]['genre'] =
                          //                       _genrecontroller.text;
                          //                   _cachedSongs[index]['year'] =
                          //                       _yearcontroller.text;
                          //                   final tag = Tag(
                          //                     title: _titlecontroller.text,
                          //                     artist: _artistcontroller.text,
                          //                     album: _albumcontroller.text,
                          //                     genre: _genrecontroller.text,
                          //                     year: _yearcontroller.text,
                          //                     albumArtist: _albumArtistController.text,
                          //                   );
                          //                   try {
                          //                     try {
                          //                       await [
                          //                         Permission.manageExternalStorage,
                          //                       ].request();
                          //                       tagger.writeTags(
                          //                         path: _cachedSongs[index]['id']
                          //                             .toString(),
                          //                         tag: tag,
                          //                       );
                          //                     } catch (e) {
                          //                       await tagger.writeTags(
                          //                         path: _cachedSongs[index]['id']
                          //                             .toString(),
                          //                         tag: tag,
                          //                       );
                          //                       ShowSnackBar().showSnackBar(
                          //                         context,
                          //                         'Successfully edited tags',
                          //                       );
                          //                     }
                          //                   } catch (e) {
                          //                     ShowSnackBar().showSnackBar(
                          //                       context,
                          //                       'Failed to edit tags',
                          //                     );
                          //                   }
                          //                 },
                          //                 child: const Text(
                          //                   'Ok',
                          //                   style: TextStyle(color: Colors.white),
                          //                 ),
                          //               ),
                          //               const SizedBox(
                          //                 width: 5,
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     }
                          //     if (value == 2) {
                          //       try {
                          //         File(_cachedSongs[index]['id'].toString()).delete();
                          //         ShowSnackBar().showSnackBar(
                          //           context,
                          //           'Deleted ${_cachedSongs[index]['id'].split('/').last}',
                          //         );
                          //         if (_cachedAlbums[_cachedSongs[index]['album']]
                          //                 .length ==
                          //             1) {
                          //           sortedCachedAlbumKeysList
                          //               .remove(_cachedSongs[index]['album']);
                          //         }
                          //         _cachedAlbums[_cachedSongs[index]['album']]
                          //             .remove(_cachedSongs[index]);

                          //         if (_cachedArtists[_cachedSongs[index]['artist']]
                          //                 .length ==
                          //             1) {
                          //           sortedCachedArtistKeysList
                          //               .remove(_cachedSongs[index]['artist']);
                          //         }
                          //         _cachedArtists[_cachedSongs[index]['artist']]
                          //             .remove(_cachedSongs[index]);

                          //         if (_cachedGenres[_cachedSongs[index]['genre']]
                          //                 .length ==
                          //             1) {
                          //           sortedCachedGenreKeysList
                          //               .remove(_cachedSongs[index]['genre']);
                          //         }
                          //         _cachedGenres[_cachedSongs[index]['genre']]
                          //             .remove(_cachedSongs[index]);

                          //         _cachedSongs.remove(_cachedSongs[index]);
                          //       } catch (e) {
                          //         ShowSnackBar().showSnackBar(
                          //           context,
                          //           'Failed to delete ${_cachedSongs[index]['id']}',
                          //         );
                          //       }
                          //       setState(() {});
                          // }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                const Icon(Icons.playlist_add_rounded),
                                const SizedBox(width: 10.0),
                                Text(
                                  AppLocalizations.of(context)!.addToPlaylist,
                                ),
                              ],
                            ),
                          ),
                          if (widget.playlistId != null)
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  const Icon(Icons.delete_rounded),
                                  const SizedBox(width: 10.0),
                                  Text(AppLocalizations.of(context)!.remove),
                                ],
                              ),
                            ),
                          // PopupMenuItem(
                          //       value: 0,
                          //       child: Row(
                          //         children: const [
                          //           Icon(Icons.edit_rounded),
                          //           const SizedBox(width: 10.0),
                          //           Text('Rename'),
                          //         ],
                          //       ),
                          //     ),
                          //     PopupMenuItem(
                          //       value: 1,
                          //       child: Row(
                          //         children: const [
                          //           Icon(
                          //               // CupertinoIcons.tag
                          //               Icons.local_offer_rounded),
                          //           const SizedBox(width: 10.0),
                          //           Text('Edit Tags'),
                          //         ],
                          //       ),
                          //     ),
                          //     PopupMenuItem(
                          //       value: 2,
                          //       child: Row(
                          //         children: const [
                          //           Icon(Icons.delete_rounded),
                          //           const SizedBox(width: 10.0),
                          //           Text('Delete'),
                          //         ],
                          //       ),
                          //     ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) => PlayScreen(
                              songsList: widget.songs,
                              index: index,
                              offline: true,
                              fromDownloads: false,
                              fromMiniplayer: false,
                              recommend: false,
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

class AlbumsTab extends StatefulWidget {
  final Map<String, List<SongModel>> albums;
  final List<String> albumsList;
  final String tempPath;
  const AlbumsTab({
    super.key,
    required this.albums,
    required this.albumsList,
    required this.tempPath,
  });

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      shrinkWrap: true,
      itemExtent: 70.0,
      itemCount: widget.albumsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: OfflineAudioQuery.offlineArtworkWidget(
            id: widget.albums[widget.albumsList[index]]![0].id,
            type: ArtworkType.AUDIO,
            tempPath: widget.tempPath,
            fileName:
                widget.albums[widget.albumsList[index]]![0].displayNameWOExt,
          ),
          title: Text(
            widget.albumsList[index],
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${widget.albums[widget.albumsList[index]]!.length} ${AppLocalizations.of(context)!.songs}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MusicsDash(
                  title: widget.albumsList[index],
                  cachedSongs: widget.albums[widget.albumsList[index]],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
