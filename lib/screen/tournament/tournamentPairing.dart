/** TODO: find a way to keep track of the round number
 */
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/assets/tournamentStyle.dart';
import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/tournamentLogic.dart';
import 'package:vcounter/resources/tournamentDialog.dart';

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
      _logic = new TournamentLogic(this, playersNames.length, roundNo, playersNames);
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
        child: ListView.builder(
          itemCount: _logic.currentRount +2,
          itemBuilder: (BuildContext context, int index){
            if (index == 0) return Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Abbinamenti: ", style: standardStyle()),
            );//end Padding
            else if (index == _logic.currentRount +1){
              return Center(
                child: RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Nuovo Turno', style: TextStyle(color: Colors.white)),
                  ),//end Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),//end RoundedRectangleBorder
                  color: vpurple,
                  onPressed: () => null,
                ),//end RaisedButton
              );//end Center
            }
            else return _pairingOrder(index);
          }
        ),//end ListView
      ),//end Padding
    );
  }

  /** return a column with the pairing order and the possibility of randomly change it
   *  TODO: add the possibility to manually change the order
   */
  Widget _pairingOrder(int _roundNo){
    List _children = new List<Widget>();
    _children.add(standardPadding(Text('Turno $_roundNo')));
    for (int i = 0; i < _logic.seating.length; i++ ){
      _children.add(standardPadding(_pairingWidget(_logic.seating[i], i, _roundNo), value: 4.0));
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
  Widget _pairingWidget(List _player, int _tableIndex, int _round){
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
                builder: (BuildContext context) => _resultAlertDialog(context, _player, _round),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: _resultButton(_round, _player[0], _player[1]),
                // Text("Risultato", style: TextStyle(color: Colors.blue, fontSize: 16.0, decoration: TextDecoration.underline)),
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
  Widget _resultAlertDialog(BuildContext _context, List _player, int _round){
    return TournamentDialog(_player ,_logic, _round, saveResult: (){
      print('saved');
    });
  }

  /** Return the correct text based on the relative game in the tournament
   *  round:  the round no
   *  playerA: the first player
   *  playerB: the second player
   */
  Widget _resultButton(int round, String playerA, String playerB){
    int _tmpindex=-1;
    if (_logic.tournamentResult[round] != null){
      _tmpindex = _logic.tournamentResult[round].indexWhere((game) => game.winner == playerA || game.winner == playerB);
      print(_tmpindex);
    }
    if (_tmpindex >= 0 ){
      GameResult _result = _logic.tournamentResult[round][_tmpindex];
      return Text("${_result.winner} vince per ${_result.playerAWingGame} - ${_result.playerBWingGame}", style: TextStyle(fontSize: 16.0, decoration: TextDecoration.underline));
    } else return Text("Risultato", style: TextStyle(color: Colors.blue, fontSize: 16.0, decoration: TextDecoration.underline));
  }

  /** forcefully refresh the state
   */
  void refresh() {
    setState(() {});
  }
}
