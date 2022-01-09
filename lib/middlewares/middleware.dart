import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/state/state.dart';
import 'package:vcounter/reducers/reducer.dart';
import 'package:vcounter/actions/action.dart';
import 'package:vcounter/services/wrapper.dart';

standardMiddleware(Store<AppState> store, dynamic action, NextDispatcher next){
  String actionName;
  String _actionName = action.toString();
  switch (_actionName){
    // case CounterAction.INCREMENT:
    //   actionName = 'Incremento';
    // break;
    // case CounterAction.DECREMENT:
    //   actionName = 'Decremento';
    // break;
    case "ChangeNightMode":
      actionName = "ChangeNightMode";
      Wrapper _wrapper = new Wrapper();
      _wrapper.changeNightMode();//TODO: check db side action
    break;

    default:
      actionName = 'Operazione non riconosciuta!';
  }
  print('${DateTime.now()}: $actionName');
  next(action);
}
