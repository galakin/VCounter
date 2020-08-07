/*IDEA: add grey background to text imput*/
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
  int _playerNo = 2;
  List player = ['giocatore 1', 'giocatore 2'];
  String _tournamentName = "";
  final _formKey = GlobalKey<FormState>();


  _CreateTournametState(this._store);

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(_store, route: 'createtournament'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child:Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: 20.0
                ),//end Container
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nome Torneo',
                  ),//end InputDecoration
                ),//end TextField
                _standartPadding(
                  Text('Partecipanti:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                ),//end Standard Padding
                _standartPadding(_playersNameInput()),
              ]
            ),//end ListView
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text("Inizia Torneo", style: TextStyle(color: Colors.white)),
                  ),//end Padding
                  onPressed: (){
                    print("create tournament");
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),//end RoundedRectangleBorder
                  color: vpurple,
                ),//end RaisedButton
              ),//end Padding
            ),//end Align
          ]
        ),//end Stack
      ),//end Padding
    );//end Scaffold
  }

  /** Standard padding for all the widget in this page, tha standard value of
   *  padding is set by 16.0 pixel offset from bottom
   */
  Widget _standartPadding(Widget child){
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: child,
    );//end Padding
  }

  /** create and populate the lis of player's input name
   *
   */
  Widget _playersNameInput(){
    List _children = new List<Widget>();
    for (int i = 0; i < _playerNo +1; i++){
      /**TODO add `add new player` button*/
      if (i == _playerNo)
      _children.add(
        _standartPadding(
          RaisedButton(
            child: Container(
              width: 170,
              child: Center(child: Icon(Icons.person_add, color: Colors.white)),
            ),
            onPressed: (){
              setState(() {
                _playerNo++;
                player.add('');
              });
              print("add player");
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),//end RoundedRectangleBorder
            color: vpurple,
          ),//end RaisedButton
        ),//end _standartPadding
      );
      else _children.add( Row(
          children: [
            Container(
              width: 200,
              child: TextFormField(
                initialValue: player[i],
                validator: (value) {
                  if (value.isEmpty) return 'Inserire un nome';
                },
                onSaved: (String value) {
                  // This optional block of code can be used to run code when the user saves the form.
                },
              ),//end TextFormField
            ),//end Container
            SizedBox(width: 10.0),
            _removeAction(i),
          ]
        ),//end row
      );
    }

    return Form(
      key: _formKey,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      ),//end Column
    );//end Form
  }

  /**NOTE discard item by swipe it like a todo list*/
  Widget _removeAction(int _index){
    print('index: $_index');
    return GestureDetector(
      child: Icon(Icons.delete),
      onTap: (){
        setState(() {
          _playerNo--;
          player.removeAt(_index);
        });
      },
    );//end RaisedButton
  }
}
