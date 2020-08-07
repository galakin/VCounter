import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TournamentPairing extends StatefulWidget{
  Store _store;

  TournamentPairing(this._store);

  @override State createState() => _TournamentPairingState(_store);
}

class _TournamentPairingState extends State{
  Store _store;

  _TournamentPairingState(this._store);

  @override Widget build(BuildContext context){
    return Scaffold(
      body: Container(),
    );
  }
}
