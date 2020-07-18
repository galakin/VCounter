import 'package:flutter/material.dart';
import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/drawer.dart';

class Homepage extends StatelessWidget{

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _homepageButton(null, 'Nuova Partita', context, route: 'newgame'),
          _homepageButton(null, 'Storico Partite', context),
          _homepageButton(null, 'Nuovo Torneo', context),
          _homepageButton(null, 'Storico Tornei', context),
        ]
      ),//end Column
    );//end Scaffold
  }

  Widget _homepageButton(funct, String name, BuildContext context, {String route}){
    return Center(
      child: RaisedButton(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(name, style: TextStyle(color: Colors.white)),
        ),//end Padding
        onPressed: (){
          if (route != null) {
            print(route);
            Navigator.of(context).pushReplacementNamed(route);
          }
          /*BUG: alter is not working*/
          else  AlertDialog(
            title: Text('Attenzione'),
            content: Text('Feature in via di sviluppo!'),
          );//end AlertDialog
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),//end RoundedRectangleBorder
        color: vpurple,
      ),//end RaisedButton
    );//end Center
  }
}
