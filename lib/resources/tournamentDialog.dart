import 'package:flutter/material.dart';
import 'package:vcounter/resources/tournamentLogic.dart';

class TournamentDialog extends StatefulWidget{
  TournamentLogic _logic;
  List _players;
  var onChange;

  TournamentDialog(this._players, this._logic);

  @override State createState() => _TournamentDialogState(_players, _logic);
}

class _TournamentDialogState extends State{
  TournamentLogic _logic;
  List _players, _gameResult;
  String _winner;
  var _onChange;

  _TournamentDialogState(List _players, var _logic){
    this._logic = _logic;
    this._players = _players;
    _winner = _players[0];
  }

  @override initState(){
    super.initState();
  }

  @override Widget build(BuildContext context){
    return Container(
      child: AlertDialog(
          title: Text('Risultato'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    _radioButton(_players[0]),
                    Text("Vince ${_players[0]}"),
                  ]
                ),//end Row
                Row(
                  children: [
                    _radioButton(_players[1]),
                    Text("Vince ${_players[1]}"),
                  ]
                ),//end Row
                Row(
                  /*TODO: add padding*/
                  children: [
                    Text("per "),
                    // DropdownButton()
                    //add multiple selection
                  ]
                ),//end Row
              ],
            ),//end ListBody
          ),//end SingleChildScrollView
          actions: <Widget>[
            FlatButton(
              child: Text('Salva'),
              onPressed: ()=>print('save it!'),
            ), //end FlatButton
            FlatButton(
              child: Text('Chiudi'),
              onPressed: ()=>Navigator.of(context).pop(),
            ), //end FlatButton
          ]
        ),
    );
  }

  Widget _radioButton(String _player){
    return Radio(
      value: _player,
      groupValue: _winner,
      onChanged: (value) {
        print(value);
        setState(() {
          _winner = value;
        });
      }
    );//end Radio
  }
}
