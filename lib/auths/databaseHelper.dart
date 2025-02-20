import 'dart:async';
import 'package:mins/auths/userModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main.db');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User("
            "id INTEGER PRIMARY KEY, "
            "name TEXT, "
            "email TEXT, "
            "phone TEXT, "
            "address TEXT, "
            "age TEXT, "
            "role TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> users = [];
    for (int i = 0; i < list.length; i++) {
      users.add(User.fromMap(list[i] as Map<String, dynamic>));
    }
    return users;
  }

  Future<int> deleteUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.delete("User", where: "id = ?", whereArgs: [user.id]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;
    int res =   await dbClient.update("User", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return res > 0 ? true : false;
  }
}