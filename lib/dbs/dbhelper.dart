import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  Future<Database> openDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), "bambamdb.db"),
      onCreate: dbSchema,
      version: 1
    );
    return db;
  }

  Future<void> dbSchema(Database db, int version) async{
    await db.execute("""
      CREATE TABLE Carrito(
        carPro INTEGER,
        carNombre TEXT,
        carCant REAL
      )
    """);
  }
}