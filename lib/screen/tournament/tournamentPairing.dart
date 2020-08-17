/** TODO: find a way to keep track of the round number
 *
 */
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/assets/tournamentStyle.dart';
import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/tournamentLogic.dart';

class TournamentPairing extends StatefulWidget{
  Store _store;
  String _tournamentName;
  List _playersNames;
  int _roundNo;

  TournamentPairing(this._store, this._tournamentName, this._playersNames, this._roundNo);

  @override State createState() => _TournamentPairingState(_store, _tournamentName, _playersNames, _roundNo);
}

class _TournamentPairingState extends State{
  TournamentLogic _logic;
  Store _store;
  String _tournamentName, _byeRound;
  List _playersNames, _seating, _winningOrder, _score;
  int _roundNo;

  _TournamentPairingState(store, tournamentName, playersNames, roundNo){
      this._store = store;
      this._tournamentName = tournamentName;
      _logic = new TournamentLogic(playersNames.length, roundNo, playersNames);
  }

  @override initState(){
    super.initState();
    // _seating = new List();

  }

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(_store),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            _pairingOrder(),
          ]
        ),//end ListView
      ),//end Padding
    );
  }

  /** return a column with the pairing order and the possibility of randomly change it
   *  TODO: add the possibility to manually change the order
   */
  Widget _pairingOrder(){
    List _children = new List<Widget>();
    _children.add(Text("Abbinamenti: ", style: standardStyle()));
    for (int i = 0; i < _logic.seating.length; i++ ){
      _children.add(standardPadding(_pairingWidget(_logic.seating[i], i), value: 4.0));
    }

    if (_logic.byeRound != null) _children.add(standardPadding(_byeWidget(_logic.byeRound)));
    _children.add(standardPadding(Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Divider(thickness: 1.5),
    )));
    return standardPadding(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _children,
    ));
  }

  /** Return the table's pairing widget complete with table number, and relative player
   *  _player: the player couple assigned with the table
   *  _tableIndex_: the number of the table
   */
  Widget _pairingWidget(List _player, int _tableIndex){
    return Container(
      decoration: new BoxDecoration(
        color: lightGrey,
        borderRadius: new BorderRadius.circular(16.0),
      ),//end BoxDecoration
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Tavolo: ${_tableIndex + 1}"),
            // Expanded()
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _playerPadding(Text(_player[0])),
                  Text(_player[1]),
                ]
              ),//end Column
            ),//end Expanded
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => _resultAlertDialog(context, _player),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Risultato", style: TextStyle(color: Colors.blue, fontSize: 16.0, decoration: TextDecoration.underline)),
              )
            ),//end GestureDetector
          ]
        ),//end Row
      ),//end Padding
    ); //end Container
  }

  /** Return the padding used in the player seating order
   *  child: the player's name
   */
  Padding _playerPadding(Widget _child){
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: _child
    ); //end Padding
  }

  Widget _byeWidget(String _player){
    return Container(
      decoration: new BoxDecoration(
        color: lightGrey,
        borderRadius: new BorderRadius.circular(16.0),
      ),//end BoxDecoration
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        child: Row(
          children: [
            Text("Stronzo con il bye: $_player"),
          ]
        ),//end Row
      ),//end Padding
    ); //end Container
  }

  /** Return an alert dialog where you can insert the game's final result. the
   *  player's earned point are automatically calculated based on the game's
   *  result
   */
  Widget _resultAlertDialog(BuildContext _context, List _player){
    int _winner = 0;
    return AlertDialog(
      title: Text('Risultato'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Radio(
              value: _player[0],
              groupValue: _winner,
              onChanged: (value) {
                print(value);
                setState(() {
                  _winner = 0;
                });
              }
            ),//end Radio
            Radio(
              value: _player[1],
              groupValue: _winner,
              onChanged: (value) {
                print(value);
                setState(() {
                  _winner = 1;
                });
              }
            ),//end Radio
          ],
        ),//end ListBody
      ),//end SingleChildScrollView
      actions: <Widget>[
        FlatButton(
          child: Text('Avanti'),
          onPressed: ()=>print('save it!'),
        ), //end FlatButton
        FlatButton(
          child: Text('Chiudi'),
          onPressed: ()=>Navigator.of(_context).pop(),
        ), //end FlatButton
      ]
    );
  }
}
