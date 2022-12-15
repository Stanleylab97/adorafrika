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
import 'package:adorafrika/customWidgets/copy_clipboard.dart';
import 'package:adorafrika/customWidgets/download_button.dart';
import 'package:adorafrika/customWidgets/empty_screen.dart';
import 'package:adorafrika/customWidgets/gradient_containers.dart';
import 'package:adorafrika/customWidgets/like_button.dart';
import 'package:adorafrika/customWidgets/miniplayer.dart';
import 'package:adorafrika/customWidgets/search_bar.dart';
import 'package:adorafrika/customWidgets/snackbar.dart';
import 'package:adorafrika/customWidgets/song_tile_trailing_menu.dart';
import 'package:adorafrika/pages/playlist/Player/audioplayer.dart';
import 'package:adorafrika/pages/playlist/Player/song_list.dart';
import 'package:adorafrika/pages/playlist/Search/albums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final bool fromHome;
  final bool autofocus;
  const SearchPage({
    super.key,
    required this.query,
    this.fromHome = false,
    this.autofocus = false,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  bool status = false;
  Map searchedData = {};
  Map position = {};
  List sortedKeys = [];
  final ValueNotifier<List<String>> topSearch = ValueNotifier<List<String>>(
    [],
  );
  bool fetched = false;
  bool alertShown = false;
  bool albumFetched = false;
  bool? fromHome;
  // List search = Hive.box('settings').get('search', defaultValue: [],) as List;
  // bool showHistory =
  // Hive.box('settings').get('showHistory', defaultValue: true) as bool;
  bool liveSearch =
      Hive.box('settings').get('liveSearch', defaultValue: true) as bool;

  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.query;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> fetchResults() async {
    // this fetches top 5 songs results
    final Map result = await SaavnAPI().fetchSongSearchResults(
      searchQuery: query == '' ? widget.query : query,
      count: 5,
    );
    final List songResults = result['songs'] as List;
    if (songResults.isNotEmpty) searchedData['Songs'] = songResults;
    fetched = true;
    print('SearchData: $searchedData');
    albumFetched = false;
    setState(
      () {},
    );
  }

  Future<void> getTrendingSearch() async {
    topSearch.value = await SaavnAPI().getTopSearches();
  }

  Widget nothingFound(BuildContext context) {
    if (!alertShown) {
      ShowSnackBar().showSnackBar(
        context,
        AppLocalizations.of(context)!.useVpn,
        duration: const Duration(seconds: 5),
      );
      alertShown = true;
    }
    return emptyScreen(
      context,
      0,
      ':( ',
      100,
      AppLocalizations.of(context)!.sorry,
      60,
      AppLocalizations.of(context)!.resultsNotFound,
      20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List? value = searchedData['Songs'] as List?;
    final key = "Songs";

    fromHome ??= widget.fromHome;
    if (!status) {
      status = true;
      fromHome! ? getTrendingSearch() : fetchResults();
    }
    print("Maintenant ---->$searchedData");
    return GradientContainer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: SearchBar(
                  isYt: false,
                  controller: controller,
                  liveSearch: liveSearch,
                  autofocus: widget.autofocus,
                  hintText: AppLocalizations.of(context)!.searchText,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  body: (fromHome!)
                      ? ValueListenableBuilder(
                          valueListenable: topSearch,
                          builder: (
                            BuildContext context,
                            List<String> value,
                            Widget? child,
                          ) {
                            if (value.isEmpty) return const SizedBox();
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      25,
                                      90,
                                      10,
                                      0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .trendingSearch,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: value.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.fromLTRB(
                                      15,
                                      10,
                                      10,
                                      0,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        horizontalTitleGap: 0.0,
                                        title: Text(
                                          value[index],
                                        ),
                                        leading: const Icon(
                                          Icons.trending_up_rounded,
                                        ),
                                        onLongPress: () {
                                          copyToClipboard(
                                            context: context,
                                            text: value[index],
                                          );
                                        },
                                        onTap: () {
                                          setState(
                                            () {
                                              fetched = false;
                                              query = value[index].trim();
                                              controller.text = query;
                                              status = false;
                                              fromHome = false;
                                              searchedData = {};
                                              // search.insert(0, value[index],);
                                              // if (search.length > 5) {
                                              //   search = search.sublist(0, 5);
                                              // }
                                              // Hive.box('settings')
                                              //     .put('search', search);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : !fetched
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : (searchedData.isEmpty)
                              ? nothingFound(context)
                              : SingleChildScrollView(
                                  padding: const EdgeInsets.only(
                                    top: 70,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 25,
                                            top: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .songs,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              if (key != 'Top Result')
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    25,
                                                    0,
                                                    25,
                                                    0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (key == 'Songs') {
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                opaque: false,
                                                                pageBuilder: (
                                                                  _,
                                                                  __,
                                                                  ___,
                                                                ) =>
                                                                    SongsListPage(
                                                                  listItem: {
                                                                    'id': query ==
                                                                            ''
                                                                        ? widget
                                                                            .query
                                                                        : query,
                                                                    'title':
                                                                        key,
                                                                    'type':
                                                                        'typefile',
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              AppLocalizations
                                                                      .of(
                                                                context,
                                                              )!
                                                                  .viewAll,
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                  context,
                                                                )
                                                                    .textTheme
                                                                    .caption!
                                                                    .color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .chevron_right_rounded,
                                                              color: Theme.of(
                                                                context,
                                                              )
                                                                  .textTheme
                                                                  .caption!
                                                                  .color,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                          itemCount: value!.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 10,
                                          ),
                                          itemBuilder: (context, index) {
                                            final int count =
                                                value[index]['count'] as int? ??
                                                    0;
                                            String countText = value[index]
                                                    ['artist']
                                                .toString();
                                            count > 1
                                                ? countText =
                                                    '$count ${AppLocalizations.of(context)!.songs}'
                                                : countText =
                                                    '$count ${AppLocalizations.of(context)!.song}';
                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                left: 15.0,
                                              ),
                                              title: Text(
                                                '${value[index]["titre"]}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Text(
                                                '${value[index]["blazartiste"]}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              isThreeLine: false,
                                              leading: Card(
                                                elevation: 8,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    7.0,
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, _, __) => Image(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        'assets/images/cover.jpg'),
                                                  ),
                                                  imageUrl:
                                                      '${value[index]["thumbnail"]}',
                                                  placeholder: (context, url) =>
                                                      Image(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        'assets/images/cover.jpg'),
                                                  ),
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  DownloadButton(
                                                    data: value[index] as Map,
                                                    icon: 'download',
                                                  ),
                                                  LikeButton(
                                                    mediaItem: null,
                                                    data: value[index] as Map,
                                                  ),
                                                  SongTileTrailingMenu(
                                                    data: value[index] as Map,
                                                  ),
                                                ],
                                              ),
                                              onLongPress: () {
                                                copyToClipboard(
                                                  context: context,
                                                  text:
                                                      '${value[index]["titre"]}',
                                                );
                                              },
                                              onTap: () {
                                                print(
                                                    "value Index:${value[index]}");
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                      opaque: false,
                                                      pageBuilder: (
                                                        _,
                                                        __,
                                                        ___,
                                                      ) =>
                                                          PlayScreen(
                                                            songsList: [
                                                              value[index]
                                                            ],
                                                            index: 0,
                                                            offline: false,
                                                            fromMiniplayer:
                                                                false,
                                                            fromDownloads:
                                                                false,
                                                            recommend: false,
                                                          )),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  ])),
                  onSubmitted: (String submittedQuery) {
                    setState(
                      () {
                        fetched = false;
                        query = submittedQuery;
                        status = false;
                        fromHome = false;
                        searchedData = {};
                      },
                    );
                  },
                ),
              ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
