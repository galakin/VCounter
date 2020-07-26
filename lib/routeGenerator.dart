import 'package:flutter/material.dart';

import 'package:vcounter/screen/newGame.dart';
import 'package:vcounter/screen/homepage.dart';
import 'package:vcounter/screen/gameHistory.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case 'homepage':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => Homepage(args['store']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'newgame':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => NewGame(args['store']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'gamehistory':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => GameHistory(args['store']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      default:
        return MaterialPageRoute(builder: (_) => defaultRoute(args));
      break;
    }
  }

  static defaultRoute(var args){
    print(args);
    return MaterialPageRoute(builder: (_) =>
      Scaffold(
        body: Center(
          child: Text('route not found'),
        ),//end Center
      )//end Scaffold
    );//end MaterialPageRoute
  }
}
