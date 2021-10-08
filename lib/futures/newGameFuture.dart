import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';  //Used for restartable timer
import 'package:flutter_icons/flutter_icons.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/firestore/savegame.dart';
import 'package:vcounter/assets/logGenerator.dart';

Wrapper _wrapper = new Wrapper();

Future<Map> getTaintedGame() async{

  print(logGenerator("check if exist tainted game", "info"));
  List _tmpList = await _wrapper.retriveOldGame();
  if (_tmpList.length > 0){
    for (int i = 0; i < _tmpList.length; i++){
      print(_tmpList[i].date);
    }
  }
  return {};
}
