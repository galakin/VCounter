import 'package:vcounter/services/database.dart';

class AppState{
  String username;
  int counterValue = 0;
  LocalDatabase database;

  AppState();

  AppState.fromAnother(AppState state){
    counterValue = state.counterValue;
    database = state.database;
    username = state.username;
  }

  void addUsername(String username){this.username = username;}

  int getCounterValue(){ return counterValue; }

  void incrementCounter(){ counterValue++; }

  void decrementCounter(){ counterValue--; }

  void openDatabase() async{
    await this.database.open();
    if(database == null) print('Error during the database open operation!');
  }

}
