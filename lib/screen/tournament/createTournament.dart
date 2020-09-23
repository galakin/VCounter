/** IDEA: add grey background to text imput
 *  TODO: change `start turnament` button position to bottom-right
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/assets/tournamentStyle.dart';

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
                standardPadding(
                  Text('Partecipanti:', style: standardStyle()),
                ),//end Standard Padding
                standardPadding(_playersNameInput()),
                standardPadding(_roundNumbers()),
              ]
            ),//end ListView
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text("Inizia Torneo", style: TextStyle(color: Colors.white)),
                  ),//end Padding
                  onPressed: (){
                    print("create tournament");
                    _validateAndSubmit(context);
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

  /** create and populate the lis of player's input name
   *
   */
  Widget _playersNameInput(){
    List _children = new List<Widget>();
    for (int i = 0; i < _playerNo +1; i++){
      /**TODO add `add new player` button*/
      if (i == _playerNo)
      _children.add(
        standardPadding(
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
        ),//end _standardPadding
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
      child: Column(
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
        Text("Numero di Turni: ", style: standardStyle()),
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

  /** Check if all the fieald are correctly initialized and if so change route
   *  with the tournament's pairing one, otherwise error on the respective fieald
   *  are shown
   *  context: the page's context
   */
  void _validateAndSubmit(BuildContext context ) {
    if (_validateAndSave()){
      print("Nome torneo: $_tournamentName");
      print("Giocatori: $player");
      Navigator.of(context).pushReplacementNamed(
        "tournamentpairing",
        arguments: {'store': _store, 'playersNames': player, 'tournamentName': _tournamentName, 'roundNo': _roundNo}
      );//end Navigator
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else return false;
  }

}
