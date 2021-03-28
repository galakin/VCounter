import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void firestoreSaveGame(int _id, int _date, int _noplayer, String _player1, String _player2, String _player3, String _player4,
  int life1, int life2, int life3, int life4,
  int poison1, int poison2, int poison3, int poison4,
  int commander1, int commander2, int commander3, int commander4) async{
  print("save game to firestore...");

  final snapshot = await FirebaseFirestore.instance.collection('saved-games').doc().get();
  print(snapshot);
  CollectionReference _ref = FirebaseFirestore.instance.collection('saved-games');
  _ref.add({"id": _id});
  //print(collection.doc().snapshots());

}
