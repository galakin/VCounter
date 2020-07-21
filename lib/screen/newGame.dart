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
  List _lifeTotal;

  @override initState(){
    _startPlayer = 2;
    _lifeTotal = new List(_startPlayer);
    for (int i = 0; i < _lifeTotal.length; i++) _lifeTotal[i] = 20;
  }

  @override Widget build(BuildContext context){
    print(_lifeTotal);
    return Scaffold(
      drawer: VDrawer(route: 'newgame'),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _upperLife(),
              _middleMenuBar(),
              _lowerLife(),
            ]
          ),//end Column
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                color: Colors.black,
                height: 30,
              ),//end Container
              onTap: () => print('Opening central menu'),
            ),//end Gesture Detector
          ),//end Align
        ]
      ) ,//end Stack
    );//end Scaffold
  }

  Widget _upperLife(){
    return Expanded(
      child: Container(
        color: manaColor[0],
        child: _lifeStack(0),
      ),//end Container
    );//end Expanded
  }

  Widget _lowerLife(){
    return Expanded(
      child: Container(
        color: manaColor[1],
        child: _lifeStack(1)
      ),
    );//end Expanded
  }

  Widget _middleMenuBar(){
    return Container();
  }

  Widget _lifeStack(int lifeArrayIndex) {
    return Center(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(child: Text('${_lifeTotal[lifeArrayIndex]}', style: TextStyle(color: _lifeCounterColor(lifeArrayIndex), fontSize: 100.0))
                ),//end Container
              ]
            ),//end useless row
          ),//end Align
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                _decreaseLife(lifeArrayIndex),
                _addLife(lifeArrayIndex),
              ]
            ),//end Row
          ),//end Align
        ]
      ),//end Stack
    );//end Stack
  }

  Widget _decreaseLife(int _lifeArrayIndex){
    return Expanded(
      child: GestureDetector(
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.transparent,
            child: Center(child: Icon(Icons.chevron_left, color: Colors.white, size: 52.0))
          ),//end Container
        ),
        onTap: () => setState(() => _lifeTotal[_lifeArrayIndex]--),
      ),//end Gesture Detector
    );//end Expanded
  }

  Widget _addLife(int _lifeArrayIndex){
    return Expanded(
      child: GestureDetector(
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.transparent,
            child: Center(child: Icon(Icons.chevron_right, color: Colors.white, size: 52.0))
          ),//end Container
        ),
        onTap: () => setState(() => _lifeTotal[_lifeArrayIndex]++),
      ),//end Gesture Detector
    );//end Expanded
  }

  _lifeCounterColor(int _lifeArrayIndex){
    if (_lifeTotal[_lifeArrayIndex] > 0) return Colors.white;
    else return Colors.red;
  }
}
