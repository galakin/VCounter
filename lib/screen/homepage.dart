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
          _homepageButton(null, 'Nuova Partita'),
          _homepageButton(null, 'Storico Partite'),
          _homepageButton(null, 'Nuovo Torneo'),
          _homepageButton(null, 'Storico Tornei'),
          
        ]
      ),//end Column
    );//end Scaffold
  }

  Widget _homepageButton(funct, String name){
    return Center(
      child: RaisedButton(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(name, style: TextStyle(color: Colors.white)),
        ),//end Padding
        onPressed: () => null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),//end RoundedRectangleBorder
        color: vpurple,
      ),//end RaisedButton
    );//end Center
  }
}
