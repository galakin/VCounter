import 'package:vcounter/services/database.dart';

class AppState{
  String username;
  String userID;
  int counterValue = 0;
  LocalDatabase database;
  String _version = "0.1.0";
  bool _nightMode = false;

  AppState();

  AppState.fromAnother(AppState state){
    this.counterValue = state.counterValue;
    this.database = state.database;
    this.username = state.username;
    this.userID = state.userID;
    this._version = state.getVersion();
    this._nightMode = state.getNightMode();
  }

  void addUsername(String username){this.username = username;}

  int getCounterValue(){ return counterValue; }

  void incrementCounter(){ counterValue++; }

  void decrementCounter(){ counterValue--; }

  void openDatabase() async{
    await this.database.open();
    if(database == null) print('Error during the database open operation!');
  }

  void registerUsername(username, userID){
    this.username = username;
    this.userID = userID;
  }

  void changeNightMode(){
    this._nightMode!=_nightMode;
  }

  void setNightMode(bool _nightMode){
    this._nightMode = _nightMode;
  }

  String getVersion() => _version;
  bool getNightMode() => _nightMode;
}
