import 'package:flutter/material.dart';

class NewGame extends StatefulWidget{

  @override
  State createState()=> _NewGameState();
}

class _NewGameState extends State{
  int _startPlayer;

  @override initState(){
    _startPlayer = 2;
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          
        ]
      ),//end Stack
    );//end Scaffold
  }
}
