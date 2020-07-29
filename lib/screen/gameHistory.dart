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
          if (!snapshot.hasData) return Container(child: Text('Loading...'));
          else {
            List _result = snapshot.data;
            return ListView.builder(
              itemCount: _result.length,
              itemBuilder: (BuildContext context, int i){
                return Dismissible(
                  key: Key('$i'),
                  background: Container(color: Colors.white),
                  onDismissed: (direction) {
                    print('remove element: ${i}th');
                    _wrapper.removeOldGame(_result[i]['id']);
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
                );
              }
            );
          }
        },
      ),
    );
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
