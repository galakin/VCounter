import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class VDrawer extends StatelessWidget{
  String route;
  var parent;
  Store _store;

  VDrawer(this._store, {this.route, this.parent});

  @override Widget build(BuildContext context){
    print(route);
    return Drawer(
      child: ListView(
        children: [
          _drawerTile('Home', context, Icons.home, localroute: 'homepage'),
          _drawerTile('Nuova Partita', context, Icons.home, localroute: 'newgame'),
          _drawerTile('Storico Partite', context, Icons.home, localroute: 'gamehistory'),
          _drawerTile('Nuova Torneo', context, Icons.home, localroute: 'createtournament'),
          _drawerTile('Storico Tornei', context, Icons.home, localroute: 'tournamenthistory'),
          _drawerTile('Nuovo Vendemmiatore', context, Icons.home),
          _drawerTile('Sala d\'Onore', context, Icons.home, localroute: 'halloffame'),
          _drawerTile('Impostazioni', context, Icons.settings, localroute: 'settings'),
        ]
      ),//end ListView
    );//end Draweer
  }

  /** drawer tile object used as a blueprint for every drawer's tile
   * title: the tile title
   * return the tile
   */
  Widget _drawerTile(String title, BuildContext context, IconData icons, {String localroute}){
    if ((title == 'Home' && route == null) || (route == localroute)) return Container();
    else return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Row(
          children: [
            Padding(padding: EdgeInsets.only(right: 8.0), child:Icon(icons)),
            Text(title),
          ]
        ),//end Row
        onTap: (){
          if (route == 'newgame')parent.cancelTimer();
          if (localroute != null) Navigator.of(context).pushReplacementNamed(
            localroute,
            arguments: {'store': _store}
          );//end Navigator
        }
      ), //end ListTile
    );//end Padding
  }
}
