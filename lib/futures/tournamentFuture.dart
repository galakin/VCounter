import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> retriveTournamentRanking() async{
  List _result = new List();
  var _tmpref = FirebaseFirestore.instance.collection('terminated-tournament').limit(10);
  QuerySnapshot _docs = await _tmpref.get();
  List<Map<dynamic, dynamic>> _list = [];
  _list = _docs.docs.map((doc) => doc.data() ).toList();                     //generate the list of document saved on firebase

  print('Snapshot retrived');
  return _list;
}
