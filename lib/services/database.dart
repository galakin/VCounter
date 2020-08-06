import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  Database db;

  Future open() async{
    var databasesPath = await getDatabasesPath();
    String path = databasesPath+'localdb.db';
    this.db = await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE Games (id INTEGER PRIMARY KEY,
          date INT, noplayer INT, player1 TEXT, player2 TEXT, player3 TEXT, player4 TEXT,
          life1 INTEGER, life2 INTEGER, life3 INTEGER, life4 INTEGER,
          poison1 INTEGER, poison2 INTEGER, poison3 INTEGER, poison4 INTEGER,
          commander1 INTEGER, commander2 INTEGER, commander3 INTEGER, commander4 INTEGER)''');
        return db;
      },
      onUpgrade: (db, oldVersion, newVersion) async{
        if ( oldVersion <= 1)  await db.execute('UPDATE Games SET noplayer INT, poison1 INTEGER, poison2 INTEGER, commander1 INTEGER, commander2 INTEGER');
        if (newVersion >= 3 && oldVersion == 2) await db.execute('UPDATE Games SET date INT');
        if (newVersion >= 4 && oldVersion == 3) await db.execute('UPDATE Games SET player3 TEXT, player4 TEXT, life3 INTEGER, life4 INTEGER, poison3 INTEGER, poison4 INTEGER, commander3 INTEGER, commander4 INTEGER');
        return db;
      }
    );
  }

  /** Save locally the current game
   *
   */
  Future<void> saveGame(int id, int date, int noplayer, String player1, String player2, String player3, String player4,
    int life1, int life2, int life3, int life4,
    int poison1, int poison2, int poison3, int poison4,
    int commander1, int commander2, int commander3, int commander4)
  async{
    if(this.db ==null) await open();
    Map<String, dynamic> _gameMap = {
      'id': id,
      'noplayer': noplayer,
      'player1': player1, 'player2': player2, 'player3': player3, 'player4': player4,
      'life1': life1, 'life2': life2, 'life3': life3, 'life4': life4,
      'poison1': poison1, 'poison2': poison2, 'poison3': poison3, 'poison4': poison4,
      'commander1': commander1, 'commander2': commander2, 'commander3': commander3, 'commander4': commander4,
      'date': date,
    };
    db.insert('Games', _gameMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List> retriveOldGame() async{
    if (this.db == null) await open();
    List _result = await db.rawQuery('SELECT * FROM Games');
    return _result;
  }

  Future<void> removeOldGame(int _gameID) async{
    if (this.db == null) await open();
    await db.rawDelete('DELETE FROM Games WHERE Games.id = "$_gameID"');
  }
}
