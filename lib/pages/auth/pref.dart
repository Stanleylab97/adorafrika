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

// import 'package:blackhole/Helpers/countrycodes.dart';
import 'dart:ui';

import 'package:adorafrika/customWidgets/gradient_containers.dart';
import 'package:adorafrika/customWidgets/snackbar.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

class PrefScreen extends StatefulWidget {
  const PrefScreen({super.key});

  @override
  _PrefScreenState createState() => _PrefScreenState();
}

class _PrefScreenState extends State<PrefScreen> {
  List<String> languages = [
    'English',
    'French',
    'Swahili'

  ];
  List<bool> isSelected = [true, false];
  List preferredLanguage = Hive.box('settings')
      .get('preferredLanguage', defaultValue: ['English'])?.toList() as List;
  String region =
      Hive.box('settings').get('region', defaultValue: 'United States') as String;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 1.85,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage(
                      'assets/images/logo-AdorAfrika.png',
                    ),
                  ),
                ),
              ),
              const GradientContainer(
                child: null,
                opacity: true,
              ),
              Column(
                children: [
                 
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                    image: AssetImage(
                      'assets/images/logo-AdorAfrika.png',
                    ),
                  ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              '${AppLocalizations.of(context)!.welcome}',
                                          style: TextStyle(
                                            fontSize: 28,
                                            height: 1.0,
                                            fontWeight: FontWeight.bold,
                                            color: SizeConfig.primaryColor,
                                          ),
                                          
                                        ),
                                      ),
                                  
                                  RichText(text: TextSpan(
                                              text: AppLocalizations.of(context)!
                                                  .aboard,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                                color: Colors.yellow,
                                              ),
                                            ),),
                                 RichText(text: TextSpan(
                                          text:  AppLocalizations.of(context)!
                                                  .culture,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35,
                                            color: Colors.red,
                                          ),
                                        )),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ListTile(
                                  title: Text(
                                    AppLocalizations.of(context)!.langQue,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    height: 57.0,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[900],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        preferredLanguage.isEmpty
                                            ? 'None'
                                            : preferredLanguage.join(', '),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle( color: SizeConfig.bgColor,),
                                      ),
                                    ),
                                  ),
                                  dense: true,
                                  onTap: () {
                                    showModalBottomSheet(
                                      isDismissible: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        final List checked =
                                            List.from(preferredLanguage);
                                        return StatefulBuilder(
                                          builder: (
                                            BuildContext context,
                                            StateSetter setStt,
                                          ) {
                                            return BottomGradientContainer(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                        0,
                                                        10,
                                                        0,
                                                        10,
                                                      ),
                                                      itemCount:
                                                          languages.length,
                                                      itemBuilder:
                                                          (context, idx) {
                                                         /*    return RadioListTile<String>(
          value: checked.contains(languages[idx]),
          groupValue: languages[idx],
          title: Text(languages[idx]),
           onChanged:(bool? value) {
                     value! ? checked.add(languages[idx]) : checked.remove(languages[idx]);
                             setStt(() {});
                                                        
          },
         /* selected: selectedUser == user, */
          activeColor: Theme.of(context).colorScheme.secondary
      );
                           */                            
                            return CheckboxListTile(
                                                          activeColor: Theme.of(
                                                            context,
                                                          )
                                                              .colorScheme
                                                              .secondary,
                                                          value:
                                                              checked.contains(
                                                            languages[idx],
                                                          ),
                                                          title: Text(
                                                            languages[idx],
                                                          ),
                                                          onChanged:
                                                              (bool? value) {
                                                            value!
                                                                ? checked.add(
                                                                    languages[
                                                                        idx],
                                                                  )
                                                                : checked
                                                                    .remove(
                                                                    languages[
                                                                        idx],
                                                                  );
                                                            setStt(() {});
                                                          },
                                                        ); 
                                                      },
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!
                                                              .cancel,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              SizeConfig.primaryColor,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            preferredLanguage =
                                                                checked;
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            Hive.box('settings')
                                                                .put(
                                                              'preferredLanguage',
                                                              checked,
                                                            );
                                                          });
                                                          if (preferredLanguage
                                                              .isEmpty) {
                                                            ShowSnackBar()
                                                                .showSnackBar(
                                                              context,
                                                              AppLocalizations
                                                                      .of(
                                                                context,
                                                              )!
                                                                  .noLangSelected,
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!
                                                              .ok,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                // ListTile(
                                //   title: Text(
                                //     AppLocalizations.of(context)!.countryQue,
                                //     style: const TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                //   trailing: Container(
                                //     padding: const EdgeInsets.only(
                                //       top: 5,
                                //       bottom: 5,
                                //       left: 10,
                                //       right: 10,
                                //     ),
                                //     height: 57.0,
                                //     width: 150,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(10.0),
                                //       color: Colors.grey[900],
                                //       boxShadow: const [
                                //         BoxShadow(
                                //           color: Colors.black26,
                                //           blurRadius: 5.0,
                                //           offset: Offset(0.0, 3.0),
                                //         )
                                //       ],
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         region,
                                //         textAlign: TextAlign.end,
                                //       ),
                                //     ),
                                //   ),
                                //   dense: true,
                                //   onTap: () {
                                //     showModalBottomSheet(
                                //       isDismissible: true,
                                //       backgroundColor: Colors.transparent,
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         const Map<String, String> codes =
                                //             CountryCodes.countryCodes;
                                //         final List<String> countries =
                                //             codes.keys.toList();
                                //         return BottomGradientContainer(
                                //           borderRadius:
                                //               BorderRadius.circular(20.0),
                                //           child: ListView.builder(
                                //             physics:
                                //                 const BouncingScrollPhysics(),
                                //             shrinkWrap: true,
                                //             padding: const EdgeInsets.fromLTRB(
                                //               0,
                                //               10,
                                //               0,
                                //               10,
                                //             ),
                                //             itemCount: countries.length,
                                //             itemBuilder: (context, idx) {
                                //               return ListTileTheme(
                                //                 selectedColor: Theme.of(context)
                                //                     .colorScheme
                                //                     .secondary,
                                //                 child: ListTile(
                                //                   contentPadding:
                                //                       const EdgeInsets.only(
                                //                     left: 25.0,
                                //                     right: 25.0,
                                //                   ),
                                //                   title: Text(
                                //                     countries[idx],
                                //                   ),
                                //                   trailing: region ==
                                //                           countries[idx]
                                //                       ? const Icon(
                                //                           Icons.check_rounded,
                                //                         )
                                //                       : const SizedBox(),
                                //                   selected:
                                //                       region == countries[idx],
                                //                   onTap: () {
                                //                     region = countries[idx];
                                //                     Hive.box('settings').put(
                                //                       'region',
                                //                       region,
                                //                     );
                                //                     Navigator.pop(
                                //                       context,
                                //                     );
                                //                     setState(() {});
                                //                   },
                                //                 ),
                                //               );
                                //             },
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   },
                                // ),
                                // const SizedBox(
                                //   height: 30.0,
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.popAndPushNamed(
                                        context, '/login');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      // color: Theme.of(context).accentColor,
                                      color:  SizeConfig.primaryColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.finish,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
