import 'package:flutter/material.dart';
import 'package:vcounter/resources/tournamentLogic.dart';

class TournamentDialog extends StatefulWidget{
  TournamentLogic _logic;
  List _players;
  var onChange;
  Function saveResult;

  TournamentDialog(this._players, this._logic, {this.saveResult});

  @override State createState() => _TournamentDialogState(_players, _logic, saveResult);
}

class _TournamentDialogState extends State{
  TournamentLogic _logic;
  List _players, _gameResult;
  String _winner;
  String _gameScore;
  Function _saveResult;

  _TournamentDialogState(List _players, var _logic, var saveResult){
    this._logic = _logic;
    this._players = _players;
    this._saveResult = saveResult;
    _winner = _players[0];
  }

  @override initState(){
    super.initState();
    _gameScore = _logic.gameResult[0];
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
                  children: [
                    _radioButton("draw"),
                    Text("Parità"),
                  ]
                ),//end Row
                _finalgameScore(),
              ],
            ),//end ListBody
          ),//end SingleChildScrollView
          actions: <Widget>[
            FlatButton(
              child: Text('Salva'),
              onPressed: (){
                if (_winner == 'draw') print('game draw');
                else print(_winner+" wins with score "+_gameScore);
                _saveResult();
              },
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
      onChanged: (value)=> setState(() {
        _winner = value;
      }),
    );//end Radio
  }

  /** If the game don't end in a draw a games prompt is shown to enter the final
   *  result, otherwise nothing is shown
   */
  Widget _finalgameScore(){
    if (_winner == 'draw') return Container();
    else return Row(
      /*TODO: add padding*/
      children: [
        Text("per "),
        DropdownButton(
          value: _gameScore,
          onChanged: (var value) => setState(() => _gameScore = value),
          items: _logic.gameResult.map<DropdownMenuItem>((var value) {
            return
              DropdownMenuItem(
                value: value,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(value),
                ),
              );
          }).toList(),
        ),
        //add multiple selection
      ]
    );//end Row
  }
}
