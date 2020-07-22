import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async/async.dart';  //Used for restartable timer

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
  List _isChanged;
  List _changedval;
  List _timerList;

  @override initState(){
    _startPlayer = 2;
    _lifeTotal = new List(_startPlayer);
    _isChanged = new List<bool>(_startPlayer);
    _changedval = new List<int>(_startPlayer);
    _timerList = new List<Timer>(_startPlayer);
    for (int i = 0; i < _lifeTotal.length; i++) {
      _lifeTotal[i] = 20;
      _isChanged[i] = false;
      _changedval[i] = 0;
    }
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              color: manaColor[0],
              child: _lifeStack(0),
            ),//end Container
          ),//end Align
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: _showLifeChangeCounter(0),
            )//end Padding
          ),//end Align
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 70.0),
              child: Icon(Icons.favorite, color: Colors.white, size: 30.0)
            )//end Padding
          ),//end Align
        ]
      ),
    );//end Expanded
  }

  Widget _lowerLife(){
    return Expanded(
      child: Stack(
        children:[
          Align(
            alignment: Alignment.center,
            child: Container(
              color: manaColor[1],
              child: _lifeStack(1)
            ),
          ),//end Align
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: _showLifeChangeCounter(1),
            )//end Padding
          ),//end Align
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 70.0),
              child: Icon(Icons.favorite, color: Colors.white, size: 30.0)
            )//end Padding
          ),//end Align
        ]
      ),//end Stack
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
        onTap: () => setState(() {
          _lifeTotal[_lifeArrayIndex]--;
          _isChanged[_lifeArrayIndex] = true;
          _changedval[_lifeArrayIndex]--;
        }),

        onLongPress: () => setState(() {
          _lifeTotal[_lifeArrayIndex] -= 5;
          _isChanged[_lifeArrayIndex] = true;
          _changedval[_lifeArrayIndex] -= 5;
        }),
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
        onTap: () => setState(() {
          _lifeTotal[_lifeArrayIndex]++;
          _isChanged[_lifeArrayIndex] = true;
          _changedval[_lifeArrayIndex] += 1;
        }),
        onLongPress: () => setState(() {
          _lifeTotal[_lifeArrayIndex] += 5;
          _isChanged[_lifeArrayIndex] = true;
          _changedval[_lifeArrayIndex] += 5;
        }),
      ),//end Gesture Detector
    );//end Expanded
  }

  _lifeCounterColor(int _lifeArrayIndex){
    if (_lifeTotal[_lifeArrayIndex] > 0) return Colors.white;
    else return Colors.red;
  }

  Widget _showLifeChangeCounter(int _changeArrayIndex){
    if (_isChanged[_changeArrayIndex]){
      if (_timerList[_changeArrayIndex] == null){
        _timerList[_changeArrayIndex] = RestartableTimer(Duration(seconds: 2), _timerCallback(_changeArrayIndex));
      }
      else _timerList[_changeArrayIndex].reset();

      String _tmpCounterString = "";
      if (_changedval[_changeArrayIndex] > 0) _tmpCounterString = "+${_changedval[_changeArrayIndex]}";
      else _tmpCounterString = "${_changedval[_changeArrayIndex]}";
      return Container(
        child: Text(_tmpCounterString, style: TextStyle(color: Colors.white, fontSize: 30.0)),
      );
      setState(() => _isChanged[_changeArrayIndex] = false);
    }
    else return Container();
  }

  /** Reset the temp life counter and delete it from the GUI
   *
   */
  _timerCallback(int _listIndex){
    return () {
      setState(() {
        _timerList[_listIndex] = null;
        _isChanged[_listIndex] = false;
        _changedval[_listIndex] = 0;
      });
    };
  }
}
