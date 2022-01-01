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
import 'package:vcounter/resources/logGenerator.dart';
import 'package:vcounter/firestore/newGameFirestore.dart';

Wrapper _wrapper = new Wrapper();

Future<Map> getTaintedGame() async{

  print(logGenerator("check if exist tainted game", "info"));
  List _tmpList = await _wrapper.retriveOldGame();
  List _oldOnlineGame = await retriveOnlineGames(); //retrive the old games saved on Firebase
  print(logGenerator("old game found online: ${_oldOnlineGame.length}","info"));
  Map _lastTaintGame;
  int _date = 0;
  if (_tmpList.length == 0) return {};
  else{
    for (int i = 0; i < _tmpList.length; i++){
      if (_tmpList[i]['tainted'] != 0){
        if (_tmpList[i]['date'] > _date){
          _date = _tmpList[i]['date'];
          _lastTaintGame = _tmpList[i];
        }
      }
    }

    print("----\n$_lastTaintGame\n----");
    return _lastTaintGame;
  }
}
