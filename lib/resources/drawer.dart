import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_icons/flutter_icons.dart';


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
          _drawerTile('Nuova Partita', context, Entypo.new_message, localroute: 'newgame'),
          _drawerTile('Storico Partite', context, MaterialIcons.history, localroute: 'gamehistory'),
          _drawerTile('Nuova Torneo', context, MaterialCommunityIcons.tournament, localroute: 'createtournament'),
          _drawerTile('Storico Tornei', context, MaterialIcons.history, localroute: 'tournamenthistory'),
          _drawerTile('Nuovo Vendemmiatore', context, FontAwesome.user_plus),
          _drawerTile('Sala d\'Onore', context, FontAwesome.trophy, localroute: 'halloffame'),
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
