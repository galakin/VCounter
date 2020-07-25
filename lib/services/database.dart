import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  Database db;

  Future openDB(){
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'localdb.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Games (id INTEGER PRIMARY KEY, player1 TEXT, player2 TEXT, life1 INTEGER, life2 INTEGER)');
      }
    );

  }
}
