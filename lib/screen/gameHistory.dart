import 'package:flutter/material.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/assets/colors.dart';

class GameHistory extends StatefulWidget{

  @override State createState() => _GameHistoryState();
}

class _GameHistoryState extends State{

  Future _gameHistoryFuture;
  Wrapper _wrapper;

  @override initState() {
    super.initState();
    _wrapper = new Wrapper();
    _gameHistoryFuture = _wrapper.retriveOldGame();
  }

  @override build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(route: 'gamehistory'),
      body: FutureBuilder(
        future: _gameHistoryFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (!snapshot.hasData) return Container(child: Text('Loading...'));
          else {
            List _result = snapshot.data;
            return ListView.builder(
              itemCount: _result.length,
              itemBuilder: (BuildContext context, int i){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _lifePadding(
                        Center(child: _lifePadding(Text('${_result[i]['player1']}\t${_result[i]['life1']}', style: _lifeStyle()))),
                        space: 4.0,
                        color: manaColor[0],
                      ),
                    ),

                    Expanded(
                      child: _lifePadding(
                        Center(child: _lifePadding(Text('${_result[i]['player2']}\t${_result[i]['life2']}', style: _lifeStyle()))),
                        space: 4.0,
                        color: manaColor[1],
                      ),
                    ),
                  ]
                );
                // return Container(
                //   child: Text('Hello'),
                // );
              }
            );
          }
        },
      ),
    );
  }

  Widget _lifePadding(Widget child, {double space, Color color}){
    if (space == null) space = 16.0;
    if (color == null) color = Colors.transparent;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space),
      child: Container(
        color: color,
        child: child,
      ),//end Container
    );//end Padding
  }

  TextStyle _lifeStyle() => TextStyle(fontSize:30.0, color: Colors.white, fontWeight: FontWeight.bold);
}
