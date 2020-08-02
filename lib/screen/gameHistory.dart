/* TODO: implement swipe to remove
 * TODO: create local and cloud subcategory
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/services/wrapper.dart';

class GameHistory extends StatefulWidget{
  Store _store;
  GameHistory(this._store);

  @override State createState() => _GameHistoryState(_store);
}

class _GameHistoryState extends State{
  Store _store;
  Future _gameHistoryFuture;
  Wrapper _wrapper;
  int _listLength = 0;

  _GameHistoryState(this._store);

  @override initState() {
    super.initState();
    _wrapper = new Wrapper();
    _gameHistoryFuture = _wrapper.retriveOldGame();
  }

  @override build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(_store, route: 'gamehistory'),
      body: FutureBuilder(
        future: _gameHistoryFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (!snapshot.hasData) return Center(child: Container(child: Text('Loading...')));
          else {
            List _result = snapshot.data;
            _listLength = _result.length;
            _result.sort((a,b) {
              int dateA, dateB;
              dateA = a['date'] != null ? a['date'] : 0;
              dateB = b['date'] != null ?b['date'] : 0;
              if (dateA > dateB) return 1;
              else return 0;
            });
            int _elemNo = _result.length;

            if (_elemNo > 0){
              return ListView.builder(
                itemCount: _result.length,
                itemBuilder: (BuildContext context, int i){
                  return Dismissible(
                    key: Key('$i'),
                    background: Container(color: Colors.white),
                    onDismissed: (direction) {
                      _wrapper.removeOldGame(_result[i]['id']);
                      _elemNo--;
                    },
                    child: GestureDetector(
                      onTap: () {
                        print(_result[i]);
                        int noplayer = _result[i]['noplayer'];
                        List playerName = new List(noplayer);  //List with the player's name
                        List lifeTotal = new List(noplayer); //List with the player's life total
                        List poisonCounter = new List(noplayer); //List of player's poison counter
                        List commanderDamage = new List(noplayer); //List of Commander damage
                        for (int j = 0; j < noplayer; j++){
                          print('test${j+1}');
                          playerName[j] = _result[i]['player${j+1}'];
                          lifeTotal[j] = _result[i]['life${j+1}'];
                          poisonCounter[j] = _result[i]['poison${j+1}'];
                          commanderDamage[j] = _result[i]['commander${j+1}'];
                        }

                        print(lifeTotal);


                        Navigator.of(context).pushReplacementNamed(
                          'newgame',
                          arguments: {
                            'startPlayer': noplayer,
                            'store': _store,
                            'gameID': _result[i]['id'],
                            'lifeTotal': lifeTotal,
                            'poisonCounter': poisonCounter,
                            'commanderDamage': commanderDamage,
                            'playerName': playerName,
                          }
                        );//end Navigator
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _lifePadding(
                                Center(child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: (Text('${_result[i]['player1']}\t${_result[i]['life1']}', style: _lifeStyle()))),
                                ),
                                space: 0,
                                color: manaColor[0],
                                left: true,
                              ),
                            ),

                            Expanded(
                              child: _lifePadding(
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('${_result[i]['player2']}\t${_result[i]['life2']}', style: _lifeStyle())
                                  ),//end Padding
                                ),//end Center
                                space: 0,
                                color: manaColor[1],
                              ),//end life Padding
                            ),//end Expanded
                          ]
                        ),//end Row
                      ),//end Padding
                    ),//end GestureDetector
                  );//end Dismissible
                }
              );//end ListView
            } else return Center(
              child: Text('Nessuna partita trovata!', style: TextStyle(fontSize: 24.0)), /*TODO: change to funny text*/
            );//end Center
          }
        },
      ),//end FutureBuilder
    );//end Scaffold
  }

  Widget _lifePadding(Widget child, {double space, Color color, bool left}){
    BorderRadius border;
    if (space == null) space = 16.0;
    if (color == null) color = Colors.transparent;
    if (left != null && left) border = BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100));
    else border = BorderRadius.only(topRight: Radius.circular(100), bottomRight: Radius.circular(100));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space),
      child: Container(
        child: child,
        decoration: new BoxDecoration(
          color: color,
          borderRadius: border
        ),//end Box Decoration
      ),//end Container
    );//end Padding
  }

  TextStyle _lifeStyle() => TextStyle(fontSize:30.0, color: Colors.white, fontWeight: FontWeight.bold);
}
