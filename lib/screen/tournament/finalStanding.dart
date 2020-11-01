import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/resources/standardButton.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/assets/tournamentStyle.dart';

class FinalStanding extends StatefulWidget{
  Store _store;
  List _finalStandingList;

  FinalStanding(this._store, this._finalStandingList);

  @override State createState() => _FinalStandingState(_store, _finalStandingList);
}

class _FinalStandingState extends State{
  Store _store;
  List _finalStandingList;

  _FinalStandingState(this._store, this._finalStandingList);

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(_store),
      body: Stack(
        children:[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    Center(child: Text("Classifica finale:")),
                    SizedBox(height: 10.0),
                ]
            ),//end Column
          ),//end Padding
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: StandardButton(
                color: vpurple,
                child: Text("Home", style: standardWhiteStyle()),
                action: () => Navigator.of(context).pushReplacementNamed(
                  "homepage",
                  arguments: {'store': _store}
                ),//end Navigator
              ),//end StandardButton
            ), //end Padding
          ),//end Align
        ]
      ),//end Stack
    );//end Scaffold
  }

}
