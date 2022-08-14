import 'package:vcounter/actions/action.dart';
import 'package:vcounter/state/state.dart';
import 'package:vcounter/services/wrapper.dart';

AppState reducer(AppState prevStore, dynamic action){
  AppState newState = AppState.fromAnother(prevStore);
  String _actionName = action.toString();
  switch (_actionName){
    case "BaseAction":
      print("Base Action recived");
    break;
    case "SaveGameID":
      newState.decrementCounter();
    break;
    case "ChangeNightMode":
      newState.changeNightMode();
    break;
    case "SetNightMode":
      newState.setNightMode(action.getBaseValue());
    break;
  }
  return newState;
}
