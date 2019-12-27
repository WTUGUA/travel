
import 'package:traveltranslation/model/history.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper_history {

  static DatabaseHelper_history _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String historyTable = 'history_table';
  String historyId = 'id';
  String historySource = 'hisSource';
  String historyTatget = 'hisTar';
  String collection = 'collection';


  DatabaseHelper_history._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper_history() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper_history
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'history.db';

    // Open/create the database at a given path
    var historysDatabase = await openDatabase(
        path, version: 1, onCreate: _createDb);
    return historysDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $historyTable($historyId INTEGER PRIMARY KEY AUTOINCREMENT, $historySource TEXT, '
            '$historyTatget TEXT, $collection INTEGER)');
  }

  // Fetch Operation: Get all history objects from database
  Future<List<Map<String, dynamic>>> getHistoryMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $historyTable order by $colPriority ASC');
    //结果根据ID升序排列
    var result = await db.query(historyTable, orderBy: '$historyId ASC');
    return result;
  }

  // Insert Operation: Insert a history object to database
  Future<int> insertHistory(History history) async {
    Database db = await this.database;
    var result = await db.insert(historyTable, history.toMap());
    print("添加数据库成功");
    return result;
  }

  // Update Operation: Update a history object and save it to database
  Future<int> updateHistory(History history) async {
    var db = await this.database;
    var result = await db.update(
        historyTable, history.toMap(), where: '$historyId = ?',
        whereArgs: [history.id]);
    print("修改数据成功");
    return result;
  }

  // Delete Operation: Delete a history object from database
  Future<int> deleteHistory(int id) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $historyTable WHERE $historyId = $id');
    return result;
  }
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $historyTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'history List' [ List<history> ]
  Future<List<History>> getHistoryList() async {
    var historyMapList = await getHistoryMapList(); // Get 'Map List' from database
    int count = historyMapList.length; // Count the number of map entries in db table
    List<History> historyList = List<History>();
    // For loop to create a 'history List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      historyList.add(History.fromMapObject(historyMapList[i]));
    }
    return historyList;
  }
  //清空数据
  Future<int> clear() async {
    Database db = await this.database;
    return await db.delete(historyTable);
  }

}
