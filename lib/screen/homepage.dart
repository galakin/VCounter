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
          _homepageButton(null, 'Storico Partite', context, route: 'gamehistory'),
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
          else  _showAlertDialog(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),//end RoundedRectangleBorder
        color: vpurple,
      ),//end RaisedButton
    );//end Center
  }

  _showAlertDialog(BuildContext context){
    AlertDialog _dialog = AlertDialog(
      title: Text('Attenzione'),
      content: Text('Feature in via di sviluppo!'),
    );//end AlertDialog
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return _dialog;
      }
    );
  }

}
