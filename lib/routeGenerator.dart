import 'package:flutter/material.dart';

import 'package:vcounter/screen/newGame/newGame.dart';
import 'package:vcounter/screen/homepage.dart';
import 'package:vcounter/screen/gameHistory.dart';
import 'package:vcounter/screen/hallOfFame.dart';
import 'package:vcounter/screen/tournament/createTournament.dart';
import 'package:vcounter/screen/tournament/tournamentPairing.dart';
import 'package:vcounter/screen/tournament/finalStanding.dart';
import 'package:vcounter/screen/tournamentHistory.dart';

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
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => NewGame(
            args['store'],
            args['gameID'],
            args['startPlayer'],
            args['playerName'],
            args['lifeTotal'],
            args['poisonCounter'],
            args['commanderDamage']
          ));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'gamehistory':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => GameHistory(args['store']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'halloffame':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => HallOfFame(args['store']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'createtournament':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => CreateTournamet(args['store']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'tournamentpairing':
        if (args is Map){
          if (args['store'] != null) return MaterialPageRoute(builder: (_) => TournamentPairing(args['store'], args['tournamentName'], args['playersNames'], args['roundNo']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'finalstanding':
        if (args is Map){
          if (args['store'] != null && args['standing'] != null && args['tournamentName'] != null)
            return MaterialPageRoute(builder: (_) => FinalStanding(args['store'], args['standing'], tournamentName: args['tournamentName']));
          else if (args['store'] != null && args['standing'] != null && args['tournamentName'] == null)
            return MaterialPageRoute(builder: (_) => FinalStanding(args['store'], args['standing']));
          else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      case 'tournamenthistory':
        if (args is Map){
          if (args['store'] != null)
            return MaterialPageRoute(builder: (_) => TournamentHistory(args['store']));
            else return defaultRoute(args);
        } else return defaultRoute(args);
      break;

      default:
        return defaultRoute(args);
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
