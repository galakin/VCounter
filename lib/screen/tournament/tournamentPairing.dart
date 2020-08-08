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

class TournamentPairing extends StatefulWidget{
  Store _store;
  String _tournamentName;
  List _playersNames;
  int _roundNo;

  TournamentPairing(this._store, this._tournamentName, this._playersNames, this._roundNo);

  @override State createState() => _TournamentPairingState(_store, _tournamentName, _playersNames, _roundNo);
}

class _TournamentPairingState extends State{
  Store _store;
  String _tournamentName, _byeRound;
  List _playersNames, _seating, _winningOrder, _score;
  int _roundNo;

  _TournamentPairingState(this._store, this._tournamentName, this._playersNames, this._roundNo);

  @override initState(){
    _seating = new List();
    _playersNames = _shuffle(_playersNames);
    int _length = _playersNames.length;
    if (_playersNames.length % 2 == 1) {
      _byeRound = _playersNames[_playersNames.length -1];
      _length--;
    }
    for (int i = 0; i < _length; i+=2 ){
      _seating.add([_playersNames[i], _playersNames[i+1]]);
    }

    _score = new List<int>();
    for (int i = 0; i < _playersNames.length; i++) _score.add(0);

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

  /** taken from https://stackoverflow.com/questions/13554129/list-shuffle-in-dart
   *  pseudo-randomly shuffle the player lisf for the seating couple purpuse,
   *  if the no of players is odd the last one ((2n) +1)th is the one with the bye
   */
  List _shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  /** return a column with the pairing order and the possibility of randomly change it
   *  TODO: add the possibility to manually change the order
   */
  Widget _pairingOrder(){
    List _children = new List<Widget>();
    _children.add(Text("Abbinamenti: ", style: standardStyle()));
    for (int i = 0; i < _seating.length; i++ ){
      _children.add(standardPadding(_pairingWidget(_seating[i], i), value: 4.0));
    }

    if (_byeRound != null) _children.add(standardPadding(_byeWidget(_byeRound)));
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
              onTap: () => print("Insert final Score"),
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
}
