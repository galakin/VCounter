import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/state/state.dart';
import 'package:vcounter/reducers/reducer.dart';
import 'package:vcounter/actions/action.dart';

standardMiddleware(Store<AppState> store, dynamic action, NextDispatcher next){
  String actionName;

  switch (action){
    case CounterAction.INCREMENT:
      actionName = 'Incremento';
    break;
    case CounterAction.DECREMENT:
      actionName = 'Decremento';
    break;

    default:
      actionName = 'Operazione non riconosciuta!';
  }
  print('${DateTime.now()}: $actionName');

  next(action);
}
