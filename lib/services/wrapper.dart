import 'package:vcounter/services/database.dart';
import 'package:vcounter/resources/logGenerator.dart';

class Wrapper{
  var database;

  Wrapper({database}){
    if (database == null) database = new LocalDatabase();
  }

  Future<void> saveGame(int id, int date, int noplayer, String player1, String player2, String player3, String player4,
    int life1, int life2, int life3, int life4,
    int poison1, int poison2, int poison3, int poison4,
    int commander1, int commander2, int commander3, int commander4) async{
    if (database != null){
      /*TODO check if a saved game with same id already exist*/
      List _oldGamesWithSameID = await database.retriveOldGame(gameID: id);
      if (_oldGamesWithSameID.length == 0)
        logGenerator("no local tinted game found", "info");
        else{
        database.saveGame(id, date, noplayer, player1, player2, player3, player4, life1, life2, life3, life4, poison1, poison2, poison3, poison4, commander1, commander2, commander3, commander4);
        logGenerator("found a taint game on local db", "info");
        if (_oldGamesWithSameID.length > 1) logGenerator("more than one game with same id found on local database", "error");
        else {
          String _argsString = "";
          _argsString += " date = $life2";
          if (life1 != null)_argsString += ",life1 = $life1";
          if (life2 != null)_argsString += ", life2 = $life2";
          database.updateGame(id, _argsString);
        }
      }
      print('game saved!');
    } else  {
      print('no db found!');
    } /*TODO throw error*/
  }

  /**return list of old games saved on local memory
   *
   */
  Future retriveOldGame({int gameID=-1}) async{
    List _result = await database.retriveOldGame();
    return _result;
  }

  Future<String> removeOldGame(int _gameID) async{
    database.removeOldGame(_gameID);
    return "OK!";
  }

  /**untain saved game on local database
   * _gameID: the local game id
   */
  Future<void> untaintSavedGame(int _gameID) async{
    logGenerator("untaint saved game","info");
    database.untaintSavedGame(_gameID);
  }

  Future<List<dynamic>> untaintedGamesList() async{
    List _result = await database.untaintedGamesList();
    return _result;
  }

  /**change the local database night mode value
   */
  Future <void> changeNightMode() async {
    logGenerator("change night mode","info");
    database.setNightMode();
  }

  /**change the local database night mode value
   */
  Future <bool> retriveNightMode() async {
    /*TODO define method body*/
    return true;
  }
}
