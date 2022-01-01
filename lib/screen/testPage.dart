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

class TestPage extends StatefulWidget{

}

class _NewGameState extends State{
}
