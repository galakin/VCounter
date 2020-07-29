import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  Database db;

  Future open() async{
    var databasesPath = await getDatabasesPath();
    String path = databasesPath+'localdb.db';
    this.db = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Games (id INTEGER PRIMARY KEY, player1 TEXT, player2 TEXT, life1 INTEGER, life2 INTEGER, poison1 INTEGER, poison2 INTEGER, commander1 INTEGER, commander2 INTEGER)');
        return db;
      },
      onUpgrade: (db, oldVersion, newVersion) async{
        if ( oldVersion <= 1)  await db.execute('UPDATE Games SET poison1 INTEGER, poison2 INTEGER, commander1 INTEGER, commander2 INTEGER');
        return db;
      }
    );
  }

  /** Save locally the current game
   *
   */
  Future<void> saveGame(int id, String player1, String player2, int life1, int life2, int poison1, int poison2, int commander1, int commander2) async{
    if(this.db ==null) await open();
    Map<String, dynamic> _gameMap = {
      'id': id,
      'player1': player1,
      'player2': player2,
      'life1': life1,
      'life2': life2,
      'poison1': poison1,
      'poison2': poison2,
      'commander1': commander1,
      'commander2': commander2,
    };
    db.insert('Games', _gameMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List> retriveOldGame() async{
    if (this.db == null) await open();
    print(db);
    List _result = await db.rawQuery('SELECT * FROM Games');
    print('\n$_result\n');
    return _result;
  }

  Future<void> removeOldGame(int _gameID) async{
    if (this.db == null) await open();
    await db.rawDelete('DELETE FROM Games WHERE Games.id = "$_gameID"');
  }
}
