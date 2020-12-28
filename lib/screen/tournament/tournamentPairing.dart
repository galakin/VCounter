/** TODO: find a way to keep track of the round number
 *  TODO: use ExpansionPanel to expand round games
 */
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:vcounter/assets/tournamentStyle.dart';
import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/tournamentLogic.dart';
import 'package:vcounter/resources/tournamentDialog.dart';
import 'package:vcounter/resources/standardButton.dart';

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
  int _expandedRound=0;

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
      body: Stack(
        children:[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: _logic.currentRound +2,
              itemBuilder: (BuildContext context, int index){
                if (index == 0) return Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text("Abbinamenti: ", style: standardStyle()),
                );//end Padding
                else if (index == _logic.currentRound +1){
                  return Column(
                    children: [
                      Center(
                        child: RaisedButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('Nuovo Turno', style: TextStyle(color: Colors.white)),
                          ),//end Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),//end RoundedRectangleBorder
                          color: _logic.currentRound < _logic.maxRound ? vpurple : lightVPurple,
                          onPressed: () {
                            if (_logic.currentRound < _logic.maxRound){
                              setState(() {
                                _logic.nextRound();
                              });
                            } else return showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Numero Massimo di turno Raggiunto'),
                                  // content: SingleChildScrollView(
                                  //   child: Text('This is a demo alert dialog.'),
                                  // ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Ah, ho capito!'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),//end RaisedButton
                      ),//end Center
                      SizedBox(height: 120.0),
                    ]
                  );//end Column
                }
                else return _pairingOrder(index);
              }
            ),//end ListView
          ),//end Padding
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: BrokenButton(
                child: Container(
                  width: 135,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.timer, color: Colors.white),
                      SizedBox(width: 5.0),
                      Expanded(child: Text('Timer', style: TextStyle(color: Colors.white))),
                    ]
                  ),//end Row
                ),//end Container
                action: () {}
              ),//end StandardButton
            ),//end Padding
          ),//end Align
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 50.0),
              child: StandardButton(
                color: (_logic.maxRound != _logic.currentRound) ? lightVPurple : vpurple,
                child: Container(
                  width: 135,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(FontAwesome.trophy, color: Colors.white),
                      SizedBox(width: 5.0),
                      Expanded( child: Text('Termina Tornero', style: TextStyle(color: Colors.white))),
                    ]
                  ),//end Row
                ),//end Container
                action: (){
                  if (_logic.maxRound == _logic.currentRound){
                    var _finalStanding=_logic.generateStanding(false);

                    Navigator.of(context).pushReplacementNamed(
                      "finalstanding",
                      arguments: {'store': _store, 'standing': _finalStanding}
                      );//end Navigator
                  }
                }
              ),//end StandardButton
            ),//end Padding
          ),//end Align
        ]
      ),//end Stack
    );//end Scaffold
  }

  /** return a column with the pairing order and the possibility of randomly change it
   *
   */
  Widget _pairingOrder(int _roundNo){
    /*NOTE insert here expanding panel*/
    List _children = new List<Widget>();
    List _expansionChildren = new List<ExpansionPanel>();


    _children.add(standardPadding(Text('Turno $_roundNo')));
    for (int i = 0; i < _logic.seating.length; i++ ){
      List _playersSeating = _logic.seating[i];
      if (_roundNo < _logic.currentRound) {
          List _players = [_logic.tournamentResult[_roundNo][i].playerA, _logic.tournamentResult[_roundNo][i].playerB];
          _children.add(standardPadding(_pairingWidget(_players, i, _roundNo), value: 4.0));
      } else _children.add(standardPadding(_pairingWidget(_logic.seating[i], i, _roundNo), value: 4.0));

      // _expansionChildren.add(
      //   ExpansionPanel(
      //     isExpanded: (i==_expandedRound),
      //     // headerBuilder:  ExpansionPanelHeaderBuilder(this.context, (i==_expandedRound)),
      //     body: null,
      //   )//end ExpansionPanel
      // );
    }

    if (_logic.byeRound != null) _children.add(standardPadding(_byeWidget(_logic.byeHistory[_roundNo-1])));
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
                  _playerPadding(Text(_player[0], style: TextStyle(fontWeight: FontWeight.w600))),
                  Text(_player[1], style: TextStyle(fontWeight: FontWeight.w600)),
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
            Text("Stronzo con il bye: "),
            Text("$_player", style: TextStyle(fontWeight: FontWeight.w600)),
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
    });
  }

  /** Return the correct text based on the relative game in the tournament
   *  round:  the round no
   *  playerA: the first player
   *  playerB: the second player
   */
  Widget _resultButton(int round, String playerA, String playerB){
    int _tmpindex=-1;
    List _oldGames = _logic.tournamentResult[round];
    if ( _oldGames != null){
      _tmpindex = _logic.tournamentResult[round].indexWhere((game) => game.playerA == playerA || game.playerA == playerB);

    }
    if (_tmpindex >= 0 ){
      GameResult _result = _logic.tournamentResult[round][_tmpindex];
      String _winnerString = "${_result.winner} vince per ${_result.playerAWingGame} - ${_result.playerBWingGame}";
      if (_result.winner == "draw") _winnerString = "Parità per 1 - 1";
      return Text(_winnerString, style: TextStyle(fontSize: 16.0, decoration: TextDecoration.underline));
    } else return Text("Risultato", style: TextStyle(color: Colors.blue, fontSize: 16.0, decoration: TextDecoration.underline));
  }

  /** forcefully refresh the state
   */
  void refresh() {
    setState(() {});
  }
}
