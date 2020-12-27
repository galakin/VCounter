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
                  Center(child: Text("Classifica finale:", style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    )),//end Text
                  ),//end Center
                  Container(
                    height: MediaQuery.of(context).size.height*0.6,
                    child:ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: _finalStandingList.length,
                      itemBuilder: (BuildContext context, int index){
                        Color _textColor = Colors.black;
                        if (index == 0) _textColor = Color.fromRGBO(92, 89, 65, 100);
                        else if (index == 1) _textColor = Color.fromRGBO(122, 130, 128, 100);
                        else if (index == 2) _textColor = Color.fromRGBO(133, 86, 0, 100);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical:8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 42.0),
                                child: Text("${index+1}°: ", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),
                              )),
                              Text(_finalStandingList[index], style: TextStyle(
                                color: _textColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              )),//end Text
                            ]
                          ),//end Row
                        );//end Padding
                      }
                    ),//end ListView
                  ),//end Container
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
