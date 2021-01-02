import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> retriveTournamentRanking() async{
  List _result = new List();
  QuerySnapshot _tournaments =
    await Firestore.instance.collection('old_tournament,').getDocuments();

  List <DocumentSnapshot> _tournamentsList = _tournaments.documents;
  print(_tournamentsList);
  return _result;
}
