import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/** Main method fo saving a tournament of firebase database
 *
 */
void saveTournament(String _tournamentName, List _tournamentStanding, String _tournamentID) async {
  print("save tournament");

  Map <String, dynamic> _data = {
    "tournament_id": _tournamentID,
    "tournament_date": DateTime.now().millisecondsSinceEpoch,
    "tournament_standing": _tournamentStanding,
    "tournament_name": _tournamentName
  };

  print(_data);
  if (!(await _tournamentAlreadyExist(_tournamentID))){
    CollectionReference _ref = FirebaseFirestore.instance.collection('terminated-tournament');
    var _result = _ref.add(_data);
    print("----\nsave result: ${_result}\n----");

  }

}

Future<bool> _tournamentAlreadyExist(String _tournamentID) async{
  bool _sameId = false;
  var _tmpref = FirebaseFirestore.instance.collection('terminated-tournament').where("tournament_id", isEqualTo: _tournamentID);
  QuerySnapshot _docs = await _tmpref.get();
  List<Map<dynamic, dynamic>> _list = [];
  _list = _docs.docs.map((doc) => doc.data() ).toList();                     //generate the list of document saved on firebase

  if (_list.length == 0) return false;
  else return true;
}
void safetySaveTournament(){}
