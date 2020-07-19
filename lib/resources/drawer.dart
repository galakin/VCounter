import 'package:flutter/material.dart';

class VDrawer extends StatelessWidget{
  String route;

  VDrawer({String route});

  @override Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          _drawerTile('Nuova Partita', context, localroute: 'newgame'),
          _drawerTile('Storico Partite', context),
          _drawerTile('Nuova Torneo', context),
          _drawerTile('Storico Torneo', context),
          _drawerTile('Nuovo Vendemmiatore', context),
          _drawerTile('Sala d\'Onore', context),
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
          if (localroute != null) Navigator.of(context).pushReplacementNamed(localroute);
        }
      ), //end ListTile
    );//end Padding
  }
}
