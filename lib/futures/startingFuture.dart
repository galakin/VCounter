import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/services/wrapper.dart';
import 'package:vcounter/futures/tournamentFuture.dart';
import 'package:vcounter/actions/action.dart'; 

Future<List> sartFuture(Store _store) async{
  setInitialState(_store);
  return retriveTaintedGames();
}

void setInitialState(Store _store) async{
  var _initialNightValue = await Wrapper().retriveNightMode();
  print("Nightmode value: $_initialNightValue");
  _store.dispatch(SetNightMode(_initialNightValue));
}
