import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/resources/scaffold.dart';

class Settings extends StatefulWidget{
  Store _store;

  Settings(this._store);

  State createState() => _SettingsState(_store);
}

class _SettingsState extends State{
  Store _store;

  _SettingsState(this._store);

  @override Widget build(BuildContext context){
    return MainScaffold(
      _store,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text("Aspetto: "),
              ]
            ),//end Row
          ),//end Padding
        ]
      ),//end Column
      route: "settings"
    );//end MainScaffold
  }
}
