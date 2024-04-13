// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pickup_lines/Data%20Folder/Bad_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Cheesy_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Cute_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Dirty_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Food_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Funny_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Hookup_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Motivational_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Nerd_Lines.dart';
import 'package:pickup_lines/Data%20Folder/Romantic_Lines.dart';

class topicClass {
  String topicName;
  var iconName;
  var topicColor;
  List<String> listOfLines;
  topicClass({
    required this.topicName,
    required this.iconName,
    required this.topicColor,
    required this.listOfLines,
  });
}

List<topicClass> topicList = [
  topicClass(
      topicName: "Bad",
      iconName: "bad.png",
      topicColor: Colors.lightBlue,
      listOfLines: Bad),
  topicClass(
    topicName: "Romantic",
    iconName: "romantic.png",
    topicColor: Colors.red,
    listOfLines: Romantic,
  ),
  topicClass(
    topicName: "Motivational",
    iconName: "motivational.png",
    topicColor: Colors.yellow,
    listOfLines: Motivational,
  ),
  topicClass(
    topicName: "Funny",
    iconName: "funny.png",
    topicColor: Colors.orange,
    listOfLines: Funny,
  ),
  topicClass(
      topicName: "Hookup",
      iconName: "hookup.png",
      topicColor: Colors.purpleAccent,
      listOfLines: Hookup),
  topicClass(
    topicName: "Cute",
    iconName: "cute.png",
    topicColor: Colors.pink,
    listOfLines: Cute,
  ),
  topicClass(
    topicName: "Dirty",
    iconName: "dirty.png",
    topicColor: Colors.brown,
    listOfLines: Dirty,
  ),
  topicClass(
      topicName: "Cheesy",
      iconName: "cheesy.png",
      topicColor: Colors.yellow,
      listOfLines: Cheesy),
  topicClass(
      topicName: "Food",
      iconName: "food.png",
      topicColor: Colors.green,
      listOfLines: Food),
  topicClass(
      topicName: "Nerd",
      iconName: "nerd.png",
      topicColor: Colors.blue,
      listOfLines: Nerd),
];
