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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height:30.0),
                  _standardPadding(
                    Center(child: Text("Classifica finale:", style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      )),//end Text
                    ),//end Center
                  ),//end standardPadding
                  _standardPadding(
                    Container(
                      height: MediaQuery.of(context).size.height*0.5,
                      child:ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        itemCount: _finalStandingList.length,
                        itemBuilder: (BuildContext context, int index){
                          Color _textColor = Colors.black;
                          double _fontSize = 22.0;
                          if (index == 0) {
                            _fontSize= 34.0;
                            _textColor = Color.fromRGBO(150, 130, 75, 100);}
                          else if (index == 1) {
                          _fontSize= 30.0;
                          _textColor = Color.fromRGBO(122, 130, 128, 100);}
                          else if (index == 2) {
                          _fontSize = 26.0;
                          _textColor = Color.fromRGBO(133, 86, 0, 100);}
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical:8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 42.0),
                                  child: Text("${index+1}°: ", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),
                                )),//end Padding
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
                  ),//end standardPadding
                  _standardPadding(Text("La classifica è salvata alla pagina NOME")),
                  _standardPadding(
                    Text("è possibile visionare la Hall Of Fame contenente tutti i vincitori degli scorsi tornei alla pagina NOME")),
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

  Padding _standardPadding(Widget body){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: body
    );//end Padding
  }

}
