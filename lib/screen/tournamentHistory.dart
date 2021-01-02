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
  var _tournamentFuture;

  @override initState(){
    print('init tournament state...');
    super.initState();
    _tournamentFuture=retriveTournamentRanking();
  }

  _TournamentHistoryState(this._store);

  @override Widget build(BuildContext context){
    return MainScaffold(_store,
      FutureBuilder(
        future: _tournamentFuture,
        builder: (BuildContext contest, AsyncSnapshot snapshot){
          if (snapshot.connectionState == ConnectionState.none || snapshot.hasData == null){
            return CircularIndicator();
          }
          return Container();
        }
      ),//end FutureBuilder
      route: 'tournamenthistory'
    );//end MainScaffold
  }
}
