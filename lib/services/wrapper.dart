import 'package:vcounter/services/database.dart';

class Wrapper{
  LocalDatabase database;

  Wrapper({this.database}){
    if (database == null) database = new LocalDatabase();
  }

  Future<void> saveGame(int id, int date, int noplayer, String player1, String player2, String player3, String player4,
    int life1, int life2, int life3, int life4,
    int poison1, int poison2, int poison3, int poison4,
    int commander1, int commander2, int commander3, int commander4){
    if (database != null){
      database.saveGame(id, date, noplayer, player1, player2, player3, player4, life1, life2, life3, life4, poison1, poison2, poison3, poison4, commander1, commander2, commander3, commander4);
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
}
