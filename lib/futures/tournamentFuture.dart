import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> retriveTournamentRanking() async{
  List _result = new List();
  FirebaseFirestore firestore = await FirebaseFirestore.instance;

  print('...snapshot retrived...');
  // List <DocumentSnapshot> _tournamentsList = _tournaments.documents;
  return new List();
}
