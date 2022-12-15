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


import 'package:adorafrika/apis/api.dart';
import 'package:adorafrika/customWidgets/bouncy_sliver_scroll_view.dart';
import 'package:adorafrika/customWidgets/copy_clipboard.dart';
import 'package:adorafrika/customWidgets/download_button.dart';
import 'package:adorafrika/customWidgets/gradient_containers.dart';
import 'package:adorafrika/customWidgets/like_button.dart';
import 'package:adorafrika/customWidgets/miniplayer.dart';
import 'package:adorafrika/customWidgets/playlist_popupmenu.dart';
import 'package:adorafrika/customWidgets/snackbar.dart';
import 'package:adorafrika/customWidgets/song_tile_trailing_menu.dart';
import 'package:adorafrika/pages/playlist/Player/audioplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:share_plus/share_plus.dart';

class SongsListPage extends StatefulWidget {
  final Map listItem;

  const SongsListPage({
    super.key,
    required this.listItem,
  });

  @override
  _SongsListPageState createState() => _SongsListPageState();
}

class _SongsListPageState extends State<SongsListPage> {
  int page = 1;
  bool loading = false;
  List songList = [];
  bool fetched = false;
  HtmlUnescape unescape = HtmlUnescape();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchSongs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent && !loading) {
        page += 1;
        _fetchSongs();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _fetchSongs() {
    loading = true;
    switch (widget.listItem['typefile'].toString()) {
      case 'AUDIO':
        SaavnAPI()
            .fetchSongSearchResults(
          searchQuery: widget.listItem['id'].toString(),
          page: page,
        )
            .then((value) {
          setState(() {
            songList.addAll(value['songs'] as List);
            fetched = true;
            loading = false;
          });
          if (value['error'].toString() != '') {
            ShowSnackBar().showSnackBar(
              context,
              'Error: ${value["error"]}',
              duration: const Duration(seconds: 3),
            );
          }
        });
        break;
      case 'VIDEO':
        SaavnAPI()
            .fetchSongSearchResults(searchQuery:widget.listItem['id'].toString(), page:page)
            .then((value) {
          setState(() {
            songList = value['VIDEO'] as List;
            fetched = true;
            loading = false;
          });
          if (value['error'].toString() != '') {
            ShowSnackBar().showSnackBar(
              context,
              'Error: ${value["error"]}',
              duration: const Duration(seconds: 3),
            );
          }
        });
        break;
      default:
        setState(() {
          fetched = true;
          loading = false;
        });
        ShowSnackBar().showSnackBar(
          context,
          'Error: Unsupported Type ${widget.listItem['typefile']}',
          duration: const Duration(seconds: 3),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: !fetched
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : BouncyImageSliverScrollView(
                      scrollController: _scrollController,
                      actions: [
                        MultiDownloadButton(
                          data: songList,
                          playlistName:
                              widget.listItem['titre']?.toString() ?? 'Songs',
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_rounded),
                          tooltip: AppLocalizations.of(context)!.share,
                          onPressed: () {
                            Share.share(
                              widget.listItem['fichier'].toString(),
                            );
                          },
                        ),
                        PlaylistPopupMenu(
                          data: songList,
                          title:
                              widget.listItem['titre']?.toString() ?? 'Songs',
                        ),
                      ],
                      title: unescape.convert(
                        widget.listItem['titre']?.toString() ?? 'Songs',
                      ),
                      placeholderImage: 'assets/images/cover.jpg',
                      imageUrl: widget.listItem['thumbnail']
                          ?.toString()
                    ,
                      sliverList: SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (_, __, ___) =>
                                              PlayScreen(
                                            songsList: songList,
                                            index: 0,
                                            offline: false,
                                            fromDownloads: false,
                                            fromMiniplayer: false,
                                            recommend: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        // color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 3.0),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.play_arrow_rounded,
                                              color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary ==
                                                      Colors.white
                                                  ? Colors.black
                                                  : Colors.white,
                                              size: 26.0,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .play,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary ==
                                                        Colors.white
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(width: 10.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      final List tempList = List.from(songList);
                                      tempList.shuffle();
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (_, __, ___) =>
                                              PlayScreen(
                                            songsList: tempList,
                                            index: 0,
                                            offline: false,
                                            fromDownloads: false,
                                            fromMiniplayer: false,
                                            recommend: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        border: Border.all(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        // boxShadow: const [
                                        //   BoxShadow(
                                        //     color: Colors.black26,
                                        //     blurRadius: 5.0,
                                        //     offset: Offset(0.0, 3.0),
                                        //   )
                                        // ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shuffle_rounded,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              size: 24.0,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .shuffle,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...songList.map((entry) {
                            print('morceau -> $entry');
                            return ListTile(
                              contentPadding: const EdgeInsets.only(left: 15.0),
                              title: Text(
                                '${entry["titre"]}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onLongPress: () {
                                copyToClipboard(
                                  context: context,
                                  text: '${entry["titre"]}',
                                );
                              },
                              subtitle: Text(
                                '${entry["categorie"]}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width * .18,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, _, __) => const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/cover.jpg',
                                    ),
                                  ),
                                  imageUrl:
                                      '${entry["thumbnail"]}',
                                  placeholder: (context, url) => const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/cover.jpg',
                                    ),
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DownloadButton(
                                    data: entry as Map,
                                    icon: 'download',
                                  ),
                                  LikeButton(
                                    mediaItem: null,
                                    data: entry,
                                  ),
                                  SongTileTrailingMenu(data: entry),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (_, __, ___) => PlayScreen(
                                      songsList: songList,
                                      index: songList.indexWhere(
                                        (element) => element == entry,
                                      ),
                                      offline: false,
                                      fromDownloads: false,
                                      fromMiniplayer: false,
                                      recommend: true,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList()
                        ]),
                      ),
                    ),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}
