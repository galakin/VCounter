/**NB rotation angle: `1.55`
 * TODO: change the lists length to max player and use index insted of changing the lists length
 * TODO: add the firestore new game db save
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';  //Used for restartable timer
import 'package:flutter_icons/flutter_icons.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/firestore/savegame.dart';
import 'package:vcounter/resources/logGenerator.dart';
import 'package:vcounter/futures/newGameFuture.dart';

enum Counter{LIFE, POISON, COMMANDER} //add Commaner, Anarchy, Energy, Experience

class NewGame extends StatefulWidget{
  Store _store;
  int startPlayer; // no of starting player
  int gameID; //game ID used to identify games on history page
  List playerName=[];  //List with the player's name
  List lifeTotal; //List with the player's life total
  List poisonCounter; //List of player's poison counter
  List commanderDamage; //List of Commander damage

  NewGame(this._store, this.gameID, this.startPlayer, this.playerName, this.lifeTotal, this.poisonCounter, this.commanderDamage);

  @override
  State createState()=> _NewGameState(_store, startPlayer, gameID, commanderDamage, playerName, lifeTotal, poisonCounter);
}

class _NewGameState extends State{
  Store _store;
  int _maxPlayer = 4;
  int _startLife = 20;        //no of starting player
  int startPlayer;            // no of starting player
  List playerName=[];         //List with the player's name
  List _showCounter;          //List of visualized counter
  List lifeTotal;             //List with the player's life total
  List _isChanged;            //List with boolean value if player's life is changed recently
  List _changedval;           //List with the recent change in player's life
  List _timerList;            //List withe remove changed player's life timer
  List _playerOrder;          //List withe the player's turn order, the order i peseudo-randomy generatedw
  List poisonCounter;         //List of player's poison counter
  List _counterState;         //List of player's visualized counter type
  List _counterList = [Counter.LIFE, Counter.POISON, Counter.COMMANDER];
  List commanderDamage;       //List of Commander damage
  List _startColor;           // List the randomly choose starting background color
  Timer _savegameTimer;       // timer used to save locally the game
  Wrapper _wrapper;
  int gameID; //game ID used to identify games on history page
  bool _openMenu = false, _showPopup = false, _showOrder=false, _playerPopup = false;

  _NewGameState(
    this._store,
    this.startPlayer,
    this.gameID,
    this.commanderDamage,
    this.playerName,
    this.lifeTotal,
    this.poisonCounter,
  );

  @override initState(){
    if (startPlayer == null) startPlayer = 2;
    if (gameID == null) gameID = Random().nextInt(1000000);
    if (commanderDamage == null) commanderDamage = new List(_maxPlayer);
    if (lifeTotal == null) lifeTotal = new List(_maxPlayer);
    if (poisonCounter == null) poisonCounter = new List(_maxPlayer);
    _startColor = new List<int>(_maxPlayer);
    _isChanged = new List<bool>(_maxPlayer);
    _changedval = new List<int>(_maxPlayer);
    _timerList = new List<Timer>(_maxPlayer);
    _playerOrder = new List<int>(_maxPlayer);
    _wrapper = new Wrapper();
    _showCounter = new List(_maxPlayer);
    _counterState = new List<int>(_maxPlayer);
    _savegameTimer = new Timer.periodic(Duration(seconds: 20), _savegameCallback);

    for (int i = 0; i < 4; i++) {
      if (lifeTotal[i] == null) lifeTotal[i] = _startLife;
      if (poisonCounter[i] == null) poisonCounter[i] = 0;
      if (commanderDamage[i] == null)commanderDamage[i] = 0;
      _startColor[i] = new Random().nextInt(5);
      _showCounter[i] = Counter.LIFE;
      _isChanged[i] = false;
      _changedval[i] = 0;
      _counterState[i] = 0;
    }
  }

  /**Main page widget that show the new game UI
   *
   */
  @override Widget build(BuildContext context){
    Widget _upperFrame = _innerFrame(manaColor[0], 0);
    Widget _lowerFrame = _innerFrame(manaColor[1], 1);
    if (startPlayer == 3){
      print('State length: ${_counterState.length}');
      print(startPlayer);
      print(lifeTotal.length);
      _upperFrame = _doubleFrame(manaColor[0], 0, 1);
      _lowerFrame = _innerFrame(manaColor[2], 2);

    } else if (startPlayer == 4){
      _upperFrame = _doubleFrame(manaColor[0], 0, 1);
      _lowerFrame = _doubleFrame(manaColor[1], 2, 3);

    }
    return Scaffold(
      drawer: VDrawer(_store, route: 'newgame', parent: this),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _upperFrame,
              // _middleMenuBar(),
              _lowerFrame,
            ]
          ),//end Column
          Align(
            alignment: Alignment.center,
            child: _middleMenuBar(),
          ),//end Align
          Align(
            alignment: Alignment.center,
            child: _showLifeSelector()
          ),
          Align(
            alignment: Alignment.center,
            child: _showPlayerNoPopup(),
          ),
          Align( //show the top left menu's icon opener
          alignment: Alignment.topLeft,
          child: _menuIcon(),
        )//end Align
      ]
      )//end Stack
    );//end Scaffold
  }

  /** double frame use for more than 2 player, used when there are 3+ player.
   *  on double frame the counter are place horizontaly
   *  _backgroundColor: backgrounds color
   *  _indexA: first frame index
   *  _indexB: second frame index
   */
  Widget _doubleFrame(Color _backgroundColor, int _indexA, int _indexB){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _innerFrame(manaColor[_indexA], _indexA, angle: 1.55),
          _innerFrame(manaColor[_indexB], _indexB, angle: -1.55),
        ]
      ),//end Row
    );//end Expanded
  }

  Widget _innerFrame(Color _backgroundColor, int _index, {double angle = 0}){
    if (_showOrder) return Expanded(                                            //shows the starting game order
      child: Container(
        color: _backgroundColor,
        child: Transform.rotate(
          angle: angle,
          child: GestureDetector(
            child: Center( child: Text("${_playerOrder[_index]}°", style: TextStyle(fontSize: 100.0, color: Colors.white))),
            onTap: () => setState(() => _showOrder = false),
          ),//end Gesture Detector
        ), //end Transform
      ),//end Container
    );//end Expanded

    else return Expanded(                                                       //show counter stack
      child: SwipeDetector(
        child: _showCounterFrame(_counterState[_index], _index, angle),
        onSwipeUp: () {
          if (angle == 0) setState(() => _counterState[_index]++);
        },
        onSwipeDown: () {
          if (_counterState[_index] > 0  && angle == 0) setState(() => _counterState[_index]--);
        },
        onSwipeLeft: (){ if (angle != 0) setState(() => _counterState[_index]++);},
        onSwipeRight: (){ if (angle != 0) setState(() => _counterState[_index]--);}
      ),//end SwipeDetector
    );//end Expanded
  }

  Widget _showCounterFrame(int _counterIndex, int _index, double angle){
    double _bottom = 70.0, _left = 0.0, _right = 0.0;
    Alignment _mainCounter = Alignment.center, _tmpCounter = Alignment.topCenter, _icon = Alignment.bottomCenter ;
    Widget _innerCounter = Padding(
      padding: EdgeInsets.only(top: 70.0),
      child: _showChangeCounter(_index),
    ); //end Padding
    if (angle != 0){
      _innerCounter = Container();
      _bottom = 0.0;
      if (angle > 0) {_icon = Alignment.centerLeft; _left: 8.0;}
      else {_icon = Alignment.centerRight; _right: 8.0;}
    }
    Counter _counter = _counterList[(_counterIndex%_counterList.length)];

    switch (_counter){
      case Counter.LIFE:
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: manaColor[_index],
                child: _counterStack(_index, _removeCounter, _addCounter, Counter.LIFE, angle, color: _lifeCounterColor),
              ),//end Container
            ),//end Align
            Align(
              alignment: Alignment.topCenter,
              child: _innerCounter,
            ),//end Align
            Align(
              alignment: _icon,
              child: Padding(
                padding: EdgeInsets.only(bottom: _bottom, left: _left, right: _right),
                child: Transform.rotate(
                  angle: angle,
                  child: Icon(Icons.favorite, color: Colors.white, size: 30.0)
                ),//end Transform
              )//end Padding
            ),//end Align
          ]
        );//end stack
      break;
      case Counter.POISON:
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: manaColor[_index],
                child: _counterStack(_index, _removeCounter, _addCounter, Counter.POISON, angle, color: poisonCounterColor),
              ),//end Container
            ),//end Align
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: _showChangeCounter(_index),
              )//end Padding
            ),//end Align
            Align(
              alignment: _icon,
              child: Padding(
                padding: EdgeInsets.only(bottom: _bottom, left: _left, right: _right),
                child: Transform.rotate(
                  angle: angle,
                  child: Icon(Entypo.drop, color: Colors.white, size: 30.0)
                ),//end Transform
              )//end Padding
            ),//end Align
          ]
        );//end Stack
      break;
      case Counter.COMMANDER:
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: manaColor[_index],
                child: _counterStack(_index, _removeCounter, _addCounter, Counter.COMMANDER, angle, color: _commanderCounterColor),
              ),//end Container
            ),//end Align
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: _showChangeCounter(_index),
              )//end Padding
            ),//end Align
            Align(
              alignment: _icon,
              child: Padding(
                padding: EdgeInsets.only(bottom: _bottom, left: _left, right: _right),
                child:
                Transform.rotate(
                  angle: angle,
                  child: Icon(Foundation.shield, color: Colors.white, size: 30.0)
                ),//end Transform
              )//end Padding
            ),//end Align
          ]
        );//end Stack
      break;
    }
  }

  /** If _showOrder is set to true a big white number pops out telling the player order,
   *  otherwise nothing is shown
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
                _playerPopup = false;
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
                           for (int i = 0; i < 2; i++) lifeTotal[i] = _startLife;
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
                           int _startIndex = Random().nextInt(startPlayer);
                           bool _init=true;
                           for (int i=((_startIndex)%startPlayer), j=1; (i%startPlayer) != _startIndex || _init; i++, j++ ) {
                             if (_init) _init=false;
                             _playerOrder[i%startPlayer] = j;
                           }
                           print(_playerOrder);
                           _showOrder=true;
                         });
                       }
                     ),
                   ),
                   _menuIconPadding(
                     child: GestureDetector(
                       child: Icon(Icons.people, color: Color.fromRGBO(255,255,255,1), size: 32.0),
                       onTap: () {
                         setState(() => _playerPopup = true);
                         print('selec no of player');
                       }
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.black,
              height: 5,
            ),//end Container
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/vlogo.png',
              width: 60,
              fit: BoxFit.cover,
            ),//end Image
          )
        ]
      ),//end Stack
      onTap: () => setState(() {
        _openMenu = true;
        _showOrder = false;
      }),
    );//end Gesture Detector
  }

  /** TODO rename it to counter stack
   *  return a counter modifier stack, complete with conter no and change button
   *
   */
  Widget _counterStack(int arrayIndex, var removeAction, var  addAction, Counter _counter, double angle, {var color}) {
    if (angle != 0) {
      /*NOTE find what to change*/
      print('\nCHANGE HERE!\n');
    }
    TextStyle _counterStyle;
    if (color != null) _counterStyle = TextStyle(color: color(arrayIndex), fontSize: 100.0);
    else _counterStyle = TextStyle(color: Colors.white, fontSize: 100.0);
    String _text;
    if ( _counter == Counter.LIFE) _text = '${lifeTotal[arrayIndex]}';
    else if (_counter == Counter.POISON) _text = "${poisonCounter[arrayIndex]}";
    else if (_counter == Counter.COMMANDER) _text = "${commanderDamage[arrayIndex]}";

    return Center(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: angle,
                  child: Container(child: Text(_text, style: _counterStyle)),//end Container
                ),//end Transform
              ]
            ),//end useless row
          ),//end Align
          Align(
            alignment: Alignment.center,
            child: _outerContainer(
              angle == 0,
              children: [
                removeAction(angle == 0,arrayIndex, _counter, angle),
                addAction(angle == 0, arrayIndex, _counter, angle),
              ]
            ),//end Row
          ),//end Align
        ]
      ),//end Stack
    );//end Stack
  }

  Widget _outerContainer(bool isOrizontal, {List<Widget> children}){
    if (isOrizontal) return Row(
      children: children
    );//end Row
    else return Column(
      children: children
    );//end Column
  }


  Widget _removeCounter(bool isOrizontal, int _arrayIndex, Counter _counter, double angle){
    IconData _icons = Icons.remove;
    return Expanded(
      child: GestureDetector(
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.transparent,
            child: rotate_button(isOrizontal, Center(child: Icon(_icons, color: Colors.white, size: 52.0))),
          ),//end Container
        ),//end Center
        onTap: () => setState(() {
          if (_counter == Counter.LIFE) lifeTotal[_arrayIndex]--;
          else if (_counter == Counter.POISON) poisonCounter[_arrayIndex]--;
          else if (_counter == Counter.COMMANDER) commanderDamage[_arrayIndex]--;
          _isChanged[_arrayIndex] = true;
          _changedval[_arrayIndex]--;
        }),

        onLongPress: () => setState(() {
          if (_counter == Counter.LIFE) lifeTotal[_arrayIndex]-=5;
          else if (_counter == Counter.POISON) poisonCounter[_arrayIndex]-=5;
          else if (_counter == Counter.COMMANDER) commanderDamage[_arrayIndex]-=5;
          _isChanged[_arrayIndex] = true;
          _changedval[_arrayIndex] -= 5;
        }),
      ),//end Gesture Detector
    );//end Expanded
  }

  Widget _addCounter(bool isOrizontal, int _arrayIndex, Counter _counter, double angle){
    IconData _icons = Icons.add;
    if (!isOrizontal) _icons = Icons.add;
    return Expanded(
      child: GestureDetector(
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.transparent,
            child: Center(child: Icon(_icons, color: Colors.white, size: 52.0))
          ),//end Container
        ),
        onTap: () => setState(() {
          if (_counter == Counter.LIFE) lifeTotal[_arrayIndex]++;
          else if (_counter == Counter.POISON) poisonCounter[_arrayIndex]++;
          else if (_counter == Counter.COMMANDER) commanderDamage[_arrayIndex]++;
          _isChanged[_arrayIndex] = true;
          _changedval[_arrayIndex] += 1;
        }),
        onLongPress: () => setState(() {
          if (_counter == Counter.LIFE) lifeTotal[_arrayIndex] += 5;
          else if (_counter == Counter.POISON) poisonCounter[_arrayIndex] += 5;
          else if (_counter == Counter.COMMANDER) commanderDamage[_arrayIndex] += 5;
          _isChanged[_arrayIndex] = true;
          _changedval[_arrayIndex] += 5;
        }),
      ),//end Gesture Detector
    );//end Expanded
  }

  _lifeCounterColor(int _lifeArrayIndex){
    if (lifeTotal[_lifeArrayIndex] > 0) return Colors.white;
    else return Colors.red;
  }

  poisonCounterColor(int _lifeArrayIndex){
    if (poisonCounter[_lifeArrayIndex] < 10) return Colors.white;
    else return Colors.green;
  }

  _commanderCounterColor(int _arrayIndex){
    if (commanderDamage[_arrayIndex] < 21) return Colors.white;
    else return Colors.red;
  }

  Widget _showChangeCounter(int _changeArrayIndex){
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

  /** If we need to select the no of player a popup menu button is showed
   *  otherwide an empty container is shown
   */
  Widget _showPlayerNoPopup(){
    if (_playerPopup) return Container(
      height: 170,
      width: 80,
      color: Colors.black,
      child: Column(
        children: [
          _playerNoTile(2),
          _playerNoTile(3),
          _playerNoTile(4),
        ]
      )
    );
    else return Container();
  }

  Widget _playerNoTile(int _playerNo){
    return ListTile(
      title: Text('$_playerNo', style: TextStyle(color: Colors.white)),
      onTap: () {
        setState(() {
          startPlayer = _playerNo;
          _playerPopup = false;
        });
      }
    );
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
        _startLife = _life;
        for (int i = 0; i< _maxPlayer; i++) lifeTotal[i] = _life;
      })
    );//end ListTile
  }

  Widget _menuIcon(){
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child:  Builder(builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: (){
            print("apertura del menù laterale");
            Scaffold.of(context).openDrawer();
          }
        )),//end Icon Button
      ),//end Align
    );//end Padding;
  }

  /** callback used to locally save the game score n counter to the device.
   *  the old game is visible in the old game page's
   */
  _savegameCallback(Timer t){
    int _sec = DateTime.now().millisecondsSinceEpoch;
    _wrapper.saveGame(gameID, _sec, startPlayer, "", "", "", "",
    lifeTotal[0], lifeTotal[1], lifeTotal[2], lifeTotal[3],
    poisonCounter[0], poisonCounter[1], poisonCounter[2], poisonCounter[3],
    commanderDamage[0], commanderDamage[1], commanderDamage[2], commanderDamage[3]);
    // firestoreSaveGame(gameID, _sec, startPlayer, "", "", "", "",
    //   lifeTotal[0], lifeTotal[1], lifeTotal[2], lifeTotal[3],
    //   poisonCounter[0], poisonCounter[1], poisonCounter[2], poisonCounter[3],
    //   commanderDamage[0], commanderDamage[1], commanderDamage[2], commanderDamage[3]);

    print(logGenerator('timer fired', 'info'));
  }

  /** callback used to cancel the saving timer once a new page is opened
   */
  cancelTimer(){
    if (_savegameTimer != null) {
      _savegameTimer.cancel();
      print('Timer cancelled!');
    }
  }

  Widget rotate_button(bool rotate, Widget button){
    if (!rotate){
      return Transform.rotate(
        angle: -1.55,
        child: button,
      );
    } else return button;
  }
}
