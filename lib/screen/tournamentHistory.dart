import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/resources/scaffold.dart';
import 'package:vcounter/futures/tournamentFuture.dart';
import 'package:vcounter/resources/circularIndicator.dart';

class TournamentHistory extends StatefulWidget{
  Store _store;

  TournamentHistory(this._store);

  State createState() => _TournamentHistoryState(_store);
}

class _TournamentHistoryState extends State{
  Store _store;
  Future _tournamentFuture;

  _TournamentHistoryState(this._store);

  @override initState(){
    super.initState();
    _tournamentFuture=retriveTournamentRanking();
  }

  @override Widget build(BuildContext context){
    return MainScaffold(
      _store,
      FutureBuilder(
        future: _tournamentFuture,
        builder: (BuildContext contest, AsyncSnapshot snapshot){
          if (snapshot.hasData == false){
            return CircularIndicator();
          }
          else {
            List _tournamentRanking = snapshot.data;
            if (_tournamentRanking.length == 0){
              return Text('Nessun risultato trovato!', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold));
            }
            else{
              return Text('Trovati ${_tournamentRanking.length} risultati!', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold));
            }
          }
        }
      ),//end FutureBuilder
      route: 'tournamenthistory'
    );//end MainScaffold
  }
}
