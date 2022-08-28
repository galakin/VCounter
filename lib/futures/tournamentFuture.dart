import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcounter/services/wrapper.dart';

Future<List> retriveTournamentRanking() async{
  var _tmpref = FirebaseFirestore.instance.collection('terminated-tournament').limit(10);
  QuerySnapshot _docs = await _tmpref.get();
  List<Object?> _list = [];
  _list = _docs.docs.map((doc) => doc.data() ).toList();                     //generate the list of document saved on firebase

  print('Snapshot retrived');
  return _list;
}

/**return the list of tainted games from local databse
 *
 */
// Future<List<Map>> retriveTaintedGames() async{
//   Wrapper _wrapper = new Wrapper();
//   List _result = await _wrapper.untaintedGamesList(); //.untaintedGamesList();
//   return _result;
// }
