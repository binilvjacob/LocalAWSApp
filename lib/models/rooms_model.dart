import 'package:flutter/material.dart';

class RoomsModel {
  final String image;
  final String name;
  final String temp;

  RoomsModel({
    @required this.image,
    @required this.name,
    @required this.temp,
  });
}

class LampModel {
  int lid;
  String name;
  //final String temp;

  LampModel({
    @required this.lid,
    @required this.name,
    // @required this.temp,
  });
}

class CurtainModel {
  int curid;
  String name;
  //final String temp;

  CurtainModel({
    @required this.curid,
    @required this.name,
    // @required this.temp,
  });
}
