import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/assets/colors.dart';

class CreateTournamet extends StatefulWidget{
  Store _store;

  CreateTournamet(this._store);

  @override State createState() => _CreateTournametState(_store);
}

class _CreateTournametState extends State{
  Store _store;
  List player = ['giocatore 1, giocatore 2'];

  _CreateTournametState(this._store);

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(_store, route: 'createtournament'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Nome Torneo',
              ),//end InputDecoration
            ),//end TextField
          ]
        ),//end ListView
      ),//end Padding
    );//end Scaffold
  }
}
