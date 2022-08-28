import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/** Main method for saving a game in firebase database
 */
void firestoreSaveGame(int _id, int _date, int _noplayer, String _player1, String _player2, String _player3, String _player4,
  int _life1, int _life2, int _life3, int _life4,
  int _poison1, int _poison2, int _poison3, int _poison4,
  int _commander1, int _commander2, int _commander3, int _commander4) async{
  print("save game to firestore...");

  Map <String, dynamic>_data = {
    "id": _id,
    "date": _date,
    "playerNo": _noplayer
  };

  CollectionReference _ref = FirebaseFirestore.instance.collection('saved-games');
  /*TODO find if another item with same id exist*/
  Map <String, dynamic> _gameMap={                                                                //generate base map with player 1 and player 2 info
    "id": _id,
    "date": _date,
    "no_player": _noplayer,
    "player_1": _player1,
    "player_2": _player2,
    "player_1_life": _life1,
    "player_2_life": _life2,
    "player_1_poison": _poison1,
    "player_2_poison": _poison2,
    "player_1_commander": _commander1,
    "player_2_commander": _commander2,
    /*TODO: add date*/
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

  if (!(await _gameAlreadyExist(_id))){
    var _result = _ref.add(_gameMap);
    print("----\nsave result: ${_result}\n----");
  }

  else {
    print("A game with ID: ${_id} already exist!");
    Query _tmpref = FirebaseFirestore.instance.collection('saved-games').where('id', isEqualTo: _id);
    QuerySnapshot _docs = await _tmpref.get();
    List<Object?> _list = [];
    _list = _docs.docs.map((doc) => doc.data() ).toList();                     //generate the list of document saved on firebase
    // print(_list);
    List<QueryDocumentSnapshot> _qsnap = (await _tmpref.get()).docs;
    if (_qsnap.length == 1){
      Future _fut = _qsnap[0].reference.update(_gameMap);
      print("Game updated succesfully!");
    }
  }
}
/**check if a saved game with this ID aleready exist in the firebase database to
 * avoid replicating the same game more than once
 * _id: the unversal game ID
 */
Future<bool> _gameAlreadyExist(int _id) async{
  bool _sameId = false;

  print("Check if some entry in firebase with the same ID exist...");
  CollectionReference _ref = FirebaseFirestore.instance.collection('saved-games');

  QuerySnapshot _docs = await _ref.get();
  var snapshot = await _ref.get();
  List<Object?> _list = [];
  _list = snapshot.docs.map((doc) => doc.data() ).toList();                          //generate the list of document saved on firebase

  // for (int _i = 0; _i < _list.length; _i++){
  //   if (_list[_i]['id'] != null && _list[_i]['id'] == _id) _sameId = true;
  // }
  return _sameId;
}
