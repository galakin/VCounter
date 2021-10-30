/*TODO: add possibility to delete the tournament*/
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
//import 'package:emojis/emoji.dart'; // to use Emoji utilities

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/resources/scaffold.dart';
import 'package:vcounter/futures/tournamentFuture.dart';
import 'package:vcounter/resources/circularIndicator.dart';
import 'package:vcounter/resources/parseDate.dart';
import 'package:vcounter/assets/logGenerator.dart';
import 'package:vcounter/assets/colors.dart';

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
    _tournamentFuture= retriveTournamentRanking();
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
              // print(_tournamentRanking.length);
              return Column(
                children: [
                  SizedBox(height:40.0),
                  Text('Trovati ${_tournamentNum(_tournamentRanking.length)} risultati!', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Container(
                    height: MediaQuery.of(context).size.height-100,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _tournamentRanking.length,
                      itemBuilder: (BuildContext context, int i){
                        return _resultTile(_tournamentRanking[i]);
                      }
                    )//end ListView
                  ),//end Container
                ],
              );//end Column
            }
          }
        }
      ),//end FutureBuilder
      route: 'tournamenthistory'
    );//end MainScaffold
  }

  /**Return the final result tile with all the info form the past tournament based
   * on the map extracted form firebase
   * _tournamentResult: the map that contain all the information from the past tournament
   */
  Widget _resultTile(Map _tournamentResult){
    print(_tournamentResult);
    return _tournamentTilePadding(
      GestureDetector(
        onTap: (){
          print(logGenerator(_tournamentResult['tournament_name'], "log"));
          Navigator.of(context).pushReplacementNamed(
            "finalstanding",
            arguments: {
              'store': _store,
              'tournamentName': _tournamentResult['tournament_name'],
              'standing': _tournamentResult['tournament_standing']
            }
          );
        },
        child: Container(
          decoration: new BoxDecoration(
            color: manaColor[5],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
              width: 0,
            ),//end Border
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 9), // changes position of shadow
            )],
          ),//end Box Decoration
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _parseName(_tournamentResult['tournament_name']),
              Container(width: 1.0, color: Colors.black),
              _parseDate(_tournamentResult['tournament_date']),
              Container(width: 1.0,  color: Colors.black),
              _parseWinner(_tournamentResult['tournament_standing']),
            ]
          ),//end Row
        ),//end Container
      ),
    );
  }

  /**Return the tile padding
   */
  Padding _tournamentTilePadding(Widget _child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: _child
    );
  }

  /**Return the parsing from firebase tournament result containing the tournament
   * date
   */
  Widget _parseDate(int _milliseconds){
    DateTime _tournamentDate = new DateTime.fromMillisecondsSinceEpoch(_milliseconds);
    String _dateText = parseDate(_tournamentDate);
    return Container(
      child: Text(_dateText, style: TextStyle(fontWeight: FontWeight.bold))
    );//end Container
  }

  /**Return the parsing from firebase tournament result containing the tournament
   * name
   */
  Widget _parseName(String _tournamnetName){
    return Container(
      child: Text(_tournamnetName, style: TextStyle(fontWeight: FontWeight.bold))
    );//end Container
  }

  /**Return the parsing from firebase tournament result containing the tournament
   * winner based on the tournament ranking found on cloud
   */
  Widget _parseWinner(List _tournamentRanking){
    //Emoji smile = Emoji.byName('Trophy'); // get a emoji by its name
    return Container(
      child: Text(/*"${smile.char} */"${_tournamentRanking[0]}", style: TextStyle(fontWeight: FontWeight.bold))
    );//end Container
  }

  String _tournamentNum(int _tournamentNum){
    if (_tournamentNum < 10) return "$_tournamentNum";
    else return "10+";
  }
}
