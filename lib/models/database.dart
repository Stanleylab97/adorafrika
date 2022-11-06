import 'package:flutter/material.dart';

class Song {
  final String name;
  final String singer;
  final String image;
  final int duration;
  final Color color;
  Song(
      {required this.name,
      required this.singer,
      required this.image,
      required this.duration,
      required this.color});
}

List<Song> mostPopular = [
  Song(
      name: "like it doesn't hurt",
      image: "assets/images/logo.jpeg",
      singer: "Charle Cardin",
      duration: 300,
      color: Colors.grey),
  Song(
      name: "love on the brain",
      image: "assets/images/logo.jpeg",
      singer: "Tvorchi",
      duration: 252,
      color: Colors.red),
  Song(
      name: "hail to the victor",
      image: "assets/images/logo.jpeg",
      singer: "danito & athina",
      duration: 532,
      color: Colors.orange),
  Song(
      name: "idk",
      image: "assets/images/logo.jpeg",
      singer: "ley you",
      duration: 264,
      color: Colors.blue)
];

List<Song> newRelease = [
  Song(
      name: "love on the brain",
      image: "assets/images/logo.jpeg",
      singer: "Tvorchi",
      duration: 252,
      color: Colors.red),
  Song(
      name: "like it doesn't hurt",
      image: "assets/images/logo.jpeg",
      singer: "Charle Cardin",
      duration: 300,
      color: Colors.grey),
  Song(
      name: "idk",
      image: "assets/images/logo.jpeg",
      singer: "ley you",
      duration: 264,
      color: Colors.blue),
  Song(
      name: "hail to the victor",
      image: "assets/images/logo.jpeg",
      singer: "danito & athina",
      duration: 532,
      color: Colors.orange),
];