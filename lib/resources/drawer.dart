import 'package:flutter/material.dart';

class VDrawer extends StatelessWidget{
  @override Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          _drawerTile('Nuova Partita'),
          _drawerTile('Storico Partite'),
          _drawerTile('Nuova Torneo'),
          _drawerTile('Storico Torneo'),
          _drawerTile('Nuovo Vendemmiatore'),
          _drawerTile('Sala d\'Onore'),
        ]
      ),//end ListView
    );//end Draweer
  }

  /** drawer tile object used as a blueprint for every drawer's tile
   * title: the tile title
   * return the tile
   */
  Widget _drawerTile(String title){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(title)
      ), //end ListTile
    );//end Padding
  }
}
