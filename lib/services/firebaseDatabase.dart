import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void saveFinalStanding(List _finalStanding, String _tournamentName) async{
  print("Tournament Result: $_finalStanding");
  CollectionReference _tournamentResult = FirebaseFirestore.instance.collection('tournament-ranking');
  _tournamentResult.add({"name": _tournamentName,
    "date":  Timestamp.fromDate(DateTime.now()),
    "standing": _finalStanding,
  })
    .then((_)=> print("new tournament correctly added"))
    .catchError((error) => print("unable to add tournament\nerror $error"));
}
