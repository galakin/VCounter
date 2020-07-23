import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';  //Used for restartable timer
import 'package:flutter_icons/flutter_icons.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';

class NewGame extends StatefulWidget{

  @override
  State createState()=> _NewGameState();
}

class _NewGameState extends State{
  int _startLife = 20;
  int _startPlayer;
  List _playerName=[];  //List with the player's name
  List _lifeTotal; //List with the player's life total
  List _isChanged;  //List with boolean value if player's life is changed recently
  List _changedval; //List with the recent change in player's life
  List _timerList;  //List withe remove changed player's life timer
  List _playerOrder; //List withe the player's turn order, the order i peseudo-randomy generatedw
  bool _openMenu = false, _showPopup = false, _showOrder=false;

  @override initState(){
    _startPlayer = 2;
    _lifeTotal = new List(_startPlayer);
    _isChanged = new List<bool>(_startPlayer);
    _changedval = new List<int>(_startPlayer);
    _timerList = new List<Timer>(_startPlayer);
    _playerOrder = new List<int>(_startPlayer);

    for (int i = 0; i < _lifeTotal.length; i++) {
      _lifeTotal[i] = _startLife;
      _isChanged[i] = false;
      _changedval[i] = 0;
    }
  }

  @override Widget build(BuildContext context){
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
            child: _middleMenuBar(),
          ),//end Align
          Align(
            alignment: Alignment.center,
            child: _showLifeSelector()
          )
        ]
      ) ,//end Stack
    );//end Scaffold
  }

  Widget _upperLife(){
    if (_showOrder) return Expanded(
      child: Container(
        color: manaColor[0],
        child: GestureDetector(
          child: Center( child: Text("${_playerOrder[0]}°", style: TextStyle(fontSize: 100.0, color: Colors.white))),
          onTap: () => setState(() => _showOrder = false),
        ),
      ),//end Container
    );//end Expanded

    else return Expanded(
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
    if (_showOrder) return Expanded(
      child: Container(
        color: manaColor[1],
        child: GestureDetector(
          child: Center( child: Text("${_playerOrder[1]}°", style: TextStyle(fontSize: 100.0, color: Colors.white))),
          onTap: () => setState(() => _showOrder = false),
        ),
      ),//end Container
    );//end Expanded
    else return Expanded(
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

  /** If _showOrder is set to true a big white number pops out telling the player order,
   *  otherwise nothing is shown
   *
   */
  Widget _showGameOrder(int _playerIndex){
    if (_showOrder) {
      return Container(
        child: null,
      );//end Conatainer
    }
    else return Container();
  }

  Widget _middleMenuBar(){
    if (_openMenu){
      return Stack(
        children: [
          Container(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),//end Container
              onTap: () => setState(()  {
                _openMenu = false;
                _showPopup = false;
              }),
            ),//end Gesture Detector
          ),
          Align(
            alignment: Alignment.center,
             child: Container(
               color: Colors.black,
               height: 60,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   _menuIconPadding( //restart lifepoint
                     child: GestureDetector(
                       child: Icon(Icons.replay, color: Colors.white, size: 32.0),
                       onTap: () {
                         setState(() {
                           for (int i = 0; i < 2; i++) _lifeTotal[i] = _startLife;
                           _openMenu = false;
                         });
                       }
                     ), //end Gesture Detector
                   ),//end _menuIconPadding
                   _menuIconPadding( //choose starting life
                     child: GestureDetector(
                       child: Stack(
                         children: [
                           Align(
                             alignment: Alignment.center,
                             child: Icon(Icons.favorite_border, color: Colors.white, size: 32.0),
                           ),//end Align
                         ]
                       ),
                       onTap: () {
                         setState(() => _showPopup = true);
                         print('selct starting life: $_showPopup');
                       },
                     ),//end GestureDetector
                   ),//end _menuIconPadding
                   _menuIconPadding( //generate playing order
                     child: GestureDetector(
                       child: Icon(Entypo.list, color:Colors.white, size: 32.0),
                       onTap: (){
                         setState((){
                           _openMenu= false;
                           int _startIndex = Random().nextInt(_startPlayer);
                           bool _init=true;
                           for (int i=((_startIndex)%_startPlayer), j=1; (i%_startPlayer) != _startIndex || _init; i++, j++ ) {
                             if (_init) _init=false;
                             _playerOrder[i%_startPlayer] = j;
                           }
                           print(_playerOrder);
                           _showOrder=true;
                         });
                       }
                     ),
                   ),
                   _menuIconPadding(
                     child: GestureDetector(
                       child: Icon(Icons.people, color: Color.fromRGBO(255,255,255,0.25), size: 32.0),
                       onTap: () => print('selec no of player'),
                     ),//end Gesture Detector
                   ), //selec no of player
                   //Insert Logo here
                 ]
               ),//end Row
             ),//end Cointainer
          ),//end Align
        ]
      );//end Stack
    } else return GestureDetector(
      child: Container(
        color: Colors.black,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Insert Logo here
          ]
        ),//end Row
      ),//end Container
      onTap: () => setState(() {
        _openMenu = true;
        _showOrder = false;
      }),
    );//end Gesture Detector
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
        _timerList[_changeArrayIndex] = RestartableTimer(Duration(seconds: 1), _timerCallback(_changeArrayIndex));
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

  Padding _menuIconPadding({Widget child}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: child,
    );//end Padding
  }

  /** If we need to select the starting life total a popup menu button is showed
   *  otherwide nothing is shown
   */
  Widget _showLifeSelector(){
    if (_showPopup) return Container(
      height: 170,
      width: 80,
      color: Colors.black,
      child: Column(
        children: [
          _startLifeTile(20),
          _startLifeTile(30),
          _startLifeTile(40),
        ]
      )
    );
    else return Container();
  }

  Widget _startLifeTile(int _life){
    return ListTile(
      title: Text('$_life', style: TextStyle(color: Colors.white)),
      onTap: () => setState(() {
        //_showPopup = false;
        //_openMenu = false;
        _startLife = _life;
        for (int i = 0; i< _lifeTotal.length; i++) _lifeTotal[i] = _life;
      })
    );//end ListTile
  }
}
