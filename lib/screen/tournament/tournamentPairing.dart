import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
  List _playersNames, _seating;
  int _roundNo;

  _TournamentPairingState(this._store, this._tournamentName, this._playersNames, this._roundNo);

  @override initState(){
    _seating = new List<List<String>>();
    _playersNames = _shuffle(_playersNames);
    if (_playersNames.length % 2 == 1) _byeRound = _playersNames[_playersNames.length -1];
    for (int i = 0; i < _playersNames.length; i+=2 ){
      _seating.add([_playersNames[i], _playersNames[i+1]]);
    }
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        children: [
          _pairingOrder(),
        ]
      ),//end ListView
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
    return Container();
  }

}
