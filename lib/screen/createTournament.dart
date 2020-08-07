/*IDEA: add grey background to text imput
 *  
 */
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
  int _playerNo = 2, _roundNo = 3;
  List player = ['Mimmo', 'Amarella'];
  String _tournamentName = "Torneo Ignorante";
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
                TextFormField(
                  initialValue: _tournamentName,
                  validator: (value) => value.isEmpty ? 'Inserire un nome ignorante' : null,
                  onSaved: (value) => _tournamentName = value,
                ),//end TextField
                _standartPadding(
                  Text('Partecipanti:', style: _standardStyle()),
                ),//end Standard Padding
                _standartPadding(_playersNameInput()),
                _standartPadding(_roundNumbers()),
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
                    _validateAndSubmit();
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
              /*TODO: add a max length to insert text*/
              child: TextFormField(
                initialValue: player[i],
                validator: (value) => value.isEmpty ? 'Inserire un nome valido' : null,
                onSaved: (value) => player[i] = value,
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

  /** If the player's text field is the last one of the list a remove icon is
   *  showed (upon on tap it remove the last instances of the list), otherwise
   *  non is shown
   *  _index: index in the player's name list
   */
  Widget _removeAction(int _index){
    if (_index == _playerNo-1) return GestureDetector(
      child: Icon(Icons.delete),
      onTap: (){
        setState(() {
          _playerNo--;
          player.removeAt(_index);
        });
      },
    );//end RaisedButton
    else return Container();
  }

  /** Show a row with a text imput for the round numbers, this value is not set
   *  in store and it's still modifiable after the turnament start but give a
   *  gross idea of how large the tournament shoud take
   */
  Widget _roundNumbers(){
    return Row(
      children: [
        Text("Numero di Turni: ", style: _standardStyle()),
        Container(
          width: 80,
          /*TODO: add a max length to insert text*/
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: "$_roundNo",
            validator: (value) => int.parse(value) <= 0 ? 'Inserire un numero valido' : null,
            onSaved: (value) => _roundNo = int.parse(value),
          )
        ),//end Container
      ]
    ); //end Row
  }

  void _validateAndSubmit() {
    if (_validateAndSave()){
      print("Nome torneo: $_tournamentName");
      print("Giocatori: $player");
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else return false;
  }

  TextStyle _standardStyle(){
    return TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
  }

}
