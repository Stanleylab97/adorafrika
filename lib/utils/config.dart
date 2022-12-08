//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  static Color secondaryColor = Colors.yellow.shade600;
  static Color bgColor = Color(0xFFFBFBFD);
  static Color primaryColor = Colors.green.shade600;
  static Color greenColor = Color.fromRGBO(142, 191, 69, 1);
  static Color red = Colors.red;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

//   static String getDurationFromTimestamp(var timestamp) {
//     var now = DateTime.now();
//     var date = timestamp.toDate();
//     var diff = now.difference(date);
//     DateFormat formatter = DateFormat('H:m');
//     DateFormat formatterd = DateFormat('MM/dd/yyyy');
//     DateTime dt = (timestamp as Timestamp).toDate();
//     String time = '';

//     if (diff.inMinutes < 60) {
//       return time = 'Vu il y a ${diff.inMinutes} min';
//     } else if (diff.inHours <= 24 && now.day == date.day) {
//       return time = 'Vu aujourd\'hui à ${formatter.format(dt)}';
//     } else if (diff.inHours <= 24 && diff.inDays < 2 && now.day > date.day) {
//       return time = 'Vu hier à ${formatter.format(date)}';
//     } else if (diff.inDays < 2 && now.day > date.day) {
//       return time = 'Vu hier à ${formatter.format(date)}';
//     } else if (diff.inDays > 0 && diff.inDays >= 1) {
//       return time = 'Vu le ${formatterd.format(dt)}';
//     }
//     return time;
//   }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
