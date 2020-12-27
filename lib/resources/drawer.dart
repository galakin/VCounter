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
          _drawerTile('Nuova Partita', context, localroute: 'newgame'),
          _drawerTile('Storico Partite', context, localroute: 'gamehistory'),
          _drawerTile('Nuova Torneo', context, localroute: 'createtournament'),
          _drawerTile('Storico Torneo', context),
          _drawerTile('Nuovo Vendemmiatore', context),
          _drawerTile('Sala d\'Onore', context, localroute: 'halloffame'),
          _drawerTile('Home', context, localroute: 'homepage')
        ]
      ),//end ListView
    );//end Draweer
  }

  /** drawer tile object used as a blueprint for every drawer's tile
   * title: the tile title
   * return the tile
   */
  Widget _drawerTile(String title, BuildContext context, {String localroute}){
    if (title == 'Home' && route == null) return Container();
    else return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(title),
        onTap: (){
          if(route == 'newgame')parent.cancelTimer();
          if (localroute != null) Navigator.of(context).pushReplacementNamed(
            localroute,
            arguments: {'store': _store}
          );//end Navigator
        }
      ), //end ListTile
    );//end Padding
  }
}
