import 'package:flutter/material.dart';
import 'package:vcounter/assets/colors.dart';

Widget greyOvalLayout(Widget child, {double hPadding=12.0, double vPadding=8.0, oRightPadding=0.0}){
  return Padding(
    padding: EdgeInsets.only(right: oRightPadding),
    child: Container(
      decoration: new BoxDecoration(
        color: lightGrey,
        borderRadius: new BorderRadius.circular(16.0),
      ),//end BoxDecoration
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: child,
      ),//end Padding
    ),//end COntainer
  );//end Padding

}
