import 'package:vcounter/actions/action.dart';
import 'package:vcounter/state/state.dart';

AppState reducer(AppState prevStore, dynamic action){
  AppState newState = AppState.fromAnother(prevStore);
  switch (action){
    case CounterAction.INCREMENT:
      newState.incrementCounter();
    break;
    case CounterAction.DECREMENT:
      newState.decrementCounter();
    break;
  }
  return newState;
}
