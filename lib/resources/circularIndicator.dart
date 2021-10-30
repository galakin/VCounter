import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget{
  @override Widget build(BuildContext context){
    return CircularProgressIndicator();
  }
}

class BackgroundCircularIndicator extends StatelessWidget{
  @override Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularIndicator()
      ),//end Center
    );//end Container
  }
}
