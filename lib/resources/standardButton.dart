import 'package:flutter/material.dart';
import 'package:vcounter/assets/colors.dart';

class StandardButton extends StatelessWidget{
  Widget child;
  var action;
  Color color;

  StandardButton({this.child = null, this.action = null, this.color});

  @override Widget build(BuildContext context){
    return RaisedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),//end Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),//end RoundedRectangleBorder
      color: color == null ? vpurple : color,
      onPressed: action,
    );//end RaisedButton
  }
}

class BrokenButton extends StatelessWidget{
  Widget child;
  var action;

  BrokenButton({this.child = null, this.action = null});

  @override Widget build(BuildContext context){
    return RaisedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),//end Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),//end RoundedRectangleBorder
      color: lightVPurple,
      onPressed: action,
    );//end RaisedButton
  }
}
