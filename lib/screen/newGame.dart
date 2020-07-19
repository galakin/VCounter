import 'package:flutter/material.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';

class NewGame extends StatefulWidget{

  @override
  State createState()=> _NewGameState();
}

class _NewGameState extends State{
  int _startPlayer;
  List _playerName=[];

  @override initState(){
    _startPlayer = 2;
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(route: 'newgame'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _upperLife(),
          _middleMenuBar(),
          _lowerLife(),
        ]
      ),//end Stack
    );//end Scaffold
  }

  Widget _upperLife(){
    return Expanded(
      child: Container(
        color: manaColor[0],
      ),
    );//end Expanded
  }

  Widget _lowerLife(){
    return Expanded(
      child: Container(
        color: manaColor[1],
      ),
    );//end Expanded
  }

  Widget _middleMenuBar(){
    return Container();
  }
}
