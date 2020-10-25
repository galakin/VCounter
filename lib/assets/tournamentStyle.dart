import 'package:flutter/material.dart';

/** Text standard style for the torunament's page
 */
TextStyle standardStyle(){
  return TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
}

/** Standard style smaller and with white text instead of black
 */
TextStyle standardWhiteStyle(){
  return TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white);
}


/** Standard padding for all the widget in this page, tha standard value of
 *  padding is set by 16.0 pixel offset from bottom
 */
Widget standardPadding(Widget child, {double, value=16.0}){
  return Padding(
    padding: EdgeInsets.only(top: value),
    child: child,
  );//end Padding
}
