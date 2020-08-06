import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/resources/drawer.dart';

class HallOfFame extends StatelessWidget{
  Store _store;

  HallOfFame(this._store);

  @override Widget build(BuildContext context){
    return Scaffold(
      drawer: VDrawer(_store),
      body: Center(child: Text('Questa pagina è più vuota\n del tuo bicchiere!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)))
      /*TODO center correctly the text*/
    );//end Scaffold
  }
}
