import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/assets/colors.dart';
import 'package:vcounter/resources/drawer.dart';

class MainScaffold extends StatefulWidget{
  Store _store;
  Widget _body;

  MainScaffold(this._store, this._body);

  State createState() => MainScaffoldState(_store, _body);
}

class MainScaffoldState extends State{
  Store _store;
  Widget _body;

  MainScaffoldState(this._store, this._body);

  @override Widget build(BuildContext context){
    VDrawer _drawer = new VDrawer(_store);
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    return Scaffold(
      drawer: _drawer,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Align(
              alignment: Alignment.topLeft,
              child:  Builder(builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                }
              )),//end Icon Button
            ),//end Align
          ),//end Padding
          _body                                                                 //insert the page body under the stack
        ]
      ),//end Stack
    );//end Scaffold
  }

}
