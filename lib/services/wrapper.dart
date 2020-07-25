import 'package:vcounter/services/database.dart';

class Wrapper{
  LocalDatabase database;

  Wrapper({this.database}){
    if (database == null) database = new LocalDatabase();
  }

  Future<void> saveGame(int id, String player1, String player2, int life1, int life2){
    if (database != null){
      database.saveGame(id, player1, player2, life1, life2);
      print('game saved!');
    } else  {
      print('no db found!');
    } /*TODO throw error*/
  }

  Future<List> retriveOldGame() async{
    List _result = await database.retriveOldGame();
    return _result;
  }
}
