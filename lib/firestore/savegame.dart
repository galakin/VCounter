import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void firestoreSaveGame(int _id, int _date, int _noplayer, String _player1, String _player2, String _player3, String _player4,
  int _life1, int _life2, int _life3, int _life4,
  int _poison1, int _poison2, int _poison3, int _poison4,
  int _commander1, int _commander2, int _commander3, int _commander4) async{
  print("save game to firestore...");

  final snapshot = await FirebaseFirestore.instance.collection('saved-games').doc().get();
  Map <String, dynamic>_data = snapshot.data();
  print(snapshot.data());

  /*
  CollectionReference _ref = FirebaseFirestore.instance.collection('saved-games');
  print(_id);
  print(_date);
  TODO find if another item with same id exist

  _ref.
  Map <String, dynamic> _gameMap={                                                                //generate base map with player 1 and player 2 info
    "id": _id,
    "date": 'Null',
    "no_player": _noplayer,
    "player_1": _player1,
    "player_2": _player2,
    "player_1_life": _life1,
    "player_2_life": _life2,
    "player_1_poison": _poison1,
    "player_2_poison": _poison2,
    "player_1_commander": _commander1,
    "player_2_commander": _commander2,
    TODO: add date
  };
  if (_noplayer > 2) {                                                          //if player 3 exist add this info to map
    _gameMap["player_3"] = _player3;
    _gameMap["player_3_life"] = _life3;
    _gameMap["player_3_poison"] = _poison3;
    _gameMap["player_3_commander"] = _commander3;
  }
  if (_noplayer > 3) {                                                          //if player 4 exist add this info to map
    _gameMap["player_4"] = _player4;
    _gameMap["player_4_life"] = _life4;
    _gameMap["player_4_poison"] = _poison4;
    _gameMap["player_4_commander"] = _commander4;
  }
  _ref.add(_gameMap);
  */
}
