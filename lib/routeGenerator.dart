import 'package:flutter/material.dart';

import 'package:vcounter/screen/newGame.dart';
import 'package:vcounter/screen/homepage.dart';
import 'package:vcounter/screen/gameHistory.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case 'homepage':
        return MaterialPageRoute(builder: (_) => Homepage());
      break;

      case 'newgame':
        return MaterialPageRoute(builder: (_) => NewGame());
      break;

      case 'gamehistory':
        return MaterialPageRoute(builder: (_) => GameHistory());
      break;

      default:
        return MaterialPageRoute(builder: (_) => defaultRoute());
      break;
    }
  }

  static defaultRoute(){
    return  Scaffold(
      body: Center(
        child: Text('route not found'),
      ),//end Center
    );//end Scaffold
  }
}
