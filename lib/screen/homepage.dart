import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/resources/scaffold.dart';

class Homepage extends StatefulWidget{
  Store _store;
  Homepage(this._store);

  State createState() => HomepageState(_store);
}
class HomepageState extends State{
  Store _store;

  initState(){
    super.initState();
  }

  HomepageState(this._store);
  @override Widget build(BuildContext context){
    VDrawer _drawer = new VDrawer(_store);
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return MainScaffold(
      _store,
      Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              child: Text("v${_store.state.getVersion()}",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
              ),//end TextStyle
            ),//end Padding
          ),//end Aligb
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _homepageButton(null, 'Nuova Partita', context, route: 'newgame'),
              _homepageButton(null, 'Storico Partite', context, route: 'gamehistory'),
              _homepageButton(null, 'Nuovo Torneo', context, route: 'createtournament'),
              _homepageButton(null, 'Storico Tornei', context, route: 'tournamenthistory'),
            ]
          ),//end Column
        ]
      ),//end Stack
    );//end MainScaffold
  }

  Widget _homepageButton(funct, String name, BuildContext context, {String route}){
    return Center(
      child: RaisedButton(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(name, style: TextStyle(color: Colors.white)),
        ),//end Padding
        onPressed: (){
          if (route != null) {
            print(route);
            Navigator.of(context).pushReplacementNamed(
              route,
              arguments: {'store': _store}
            );//end Navigator
          }
          else  _showAlertDialog(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),//end RoundedRectangleBorder
        color: vpurple,
      ),//end RaisedButton
    );//end Center
  }

  _showAlertDialog(BuildContext context){
    AlertDialog _dialog = AlertDialog(
      title: Text('Attenzione'),
      content: Text('Feature in via di sviluppo!'),
    );//end AlertDialog
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return _dialog;
      }
    );
  }

  /*
  void retrive_firebase_info(){
    //FirebaseFirestore firestore = FirebaseFirestore.instance;
    var collection = FirebaseFirestore.instance.collection('tournament-ranking');
    print(collection.doc().snapshots());
  }
  */
}
