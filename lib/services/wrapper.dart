import 'package:vcounter/services/database.dart';
import 'package:vcounter/resources/logGenerator.dart';

class Wrapper{
  LocalDatabase database;

  Wrapper({this.database}){
    if (database == null) database = new LocalDatabase();
  }

  Future<void> saveGame(int id, int date, int noplayer, String player1, String player2, String player3, String player4,
    int life1, int life2, int life3, int life4,
    int poison1, int poison2, int poison3, int poison4,
    int commander1, int commander2, int commander3, int commander4) async{
    if (database != null){
      /*TODO check if a saved game with same id already exist*/
      List _oldGamesWithSameID =  await database.retriveOldGame(gameID: id);
      if (_oldGamesWithSameID.length == 0)
        database.saveGame(id, date, noplayer, player1, player2, player3, player4, life1, life2, life3, life4, poison1, poison2, poison3, poison4, commander1, commander2, commander3, commander4);
      else{
        if (_oldGamesWithSameID.length > 1) logGenerator("more than one game with same id found on local database", "error");
        else {
          database.updateGame(id, "");
        }
      }
      print('game saved!');
    } else  {
      print('no db found!');
    } /*TODO throw error*/
  }

  Future<List> retriveOldGame() async{
    List _result = await database.retriveOldGame();
    return _result;
  }

  Future<void>removeOldGame(int _gameID) async{
    database.removeOldGame(_gameID);
  }

  Future<List> getOldGameFromMemory() async {
    return [];
  }

  /**untain saved game on local database
   * _gameID: the local game id
   */
  Future<void> untaintSavedGame(int _gameID) async{
    logGenerator("untaint saved game","info");
    database.untaintSavedGame(_gameID);
  }
}
