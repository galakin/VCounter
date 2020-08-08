import 'package:flutter/material.dart';

/** Text standard style for the torunament's page
 */
TextStyle standardStyle(){
  return TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
}

/** Standard padding for all the widget in this page, tha standard value of
 *  padding is set by 16.0 pixel offset from bottom
 */
Widget standartPadding(Widget child){
  return Padding(
    padding: EdgeInsets.only(top: 16.0),
    child: child,
  );//end Padding
}
