import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/resources/scaffold.dart';
import 'package:vcounter/actions/action.dart';

class Settings extends StatefulWidget{
  Store _store;

  Settings(this._store);

  State createState() => _SettingsState(_store);
}

class _SettingsState extends State{
  Store _store;
  bool _nightMode=false;

  _SettingsState(this._store);

  initState(){
    super.initState();
    //_nightMode = _store.state.getNightMode();
    print(_nightMode);
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: new VDrawer(_store, route: "settings"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _settingsRow([
            Text("Modalità notte: "),
            Switch(
              value: _nightMode,
              onChanged: (value){
                setState((){
                  _nightMode = !_nightMode;
                });
                print("nightmode value: $value");
                _store.dispatch(ChangeNightMode());
              }
            ),
          ]),//end settings row
        ]
      ),//end Column
      //route: "settings"
    );//end MainScaffold
  }

  Widget _settingsRow(List<Widget> _children){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: _children,
      ),//end Row
    );//end Padding
  }
}
