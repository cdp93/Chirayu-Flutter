import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_practical_task/ResponseData.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER,"
          "email TEXT,"
          "first_name TEXT,"
          "last_name TEXT,"
          "avatar TEXT"
          ")");
    });
  }

  newClient(DataArr newClient) async {
    final db = await database;
    //get the biggest id in the table
    /*var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];*/
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,email,first_name,last_name,avatar)"
        " VALUES (?,?,?,?,?)",
        [
          newClient.id,
          newClient.email,
          newClient.first_name,
          newClient.last_name,
          newClient.avatar
        ]);

    print("Data inserted..!");
    return raw;
  }

  /*blockOrUnblock(DataArr client) async {
    final db = await database;
    DataArr blocked = DataArr._(
        id: client.id,
        id: client.email,
        firstName: client.first_name,
        lastName: client.last_name,
        avatar: client.avatar);
    var res = await db.update("Client", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return res;
  }*/

  updateClient(DataArr newClient) async {
    final db = await database;
    var res = await db.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? DataArr.fromMap(res.first) : null;
  }

  /*Future<List<DataArr>> getBlockedClients() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);

    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }*/

  Future<List<DataArr>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<DataArr> list =
        res.isNotEmpty ? res.map((c) => DataArr.fromMap(c)).toList() : [];

    list.forEach((f) => print('DATA FROM DB:  ${f.email}'));

    //list.reversed.toList();
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Client");
  }
}
