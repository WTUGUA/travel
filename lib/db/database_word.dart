
import 'package:traveltranslation/model/word.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper_word {

  static DatabaseHelper_word _databaseHelper;    // Singleton DatabaseHelper
  Database _database;                // Singleton Database

  String wordTable = 'word_table';
  String wordId = 'id';
  String wordSource = 'sourceWord';
  String wordTatget = 'targetWord';

  DatabaseHelper_word._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper_word() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper_word._createInstance(); // This is executed only once, singleton object
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
    String path = directory.path + 'words.db';

    // Open/create the database at a given path
    var wordsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return wordsDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $wordTable($wordId INTEGER PRIMARY KEY AUTOINCREMENT, $wordSource TEXT, '
        '$wordTatget TEXT)');
  }
  // Fetch Operation: Get all word objects from database
  Future<List<Map<String, dynamic>>> getWordMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $wordTable order by $colPriority ASC');
    //结果根据ID升序排列
    var result = await db.query(wordTable, orderBy: '$wordId ASC');
    return result;
  }
  // Insert Operation: Insert a word object to database
  Future<int> insertWord(Word word) async {
    Database db = await this.database;
    var result = await db.insert(wordTable, word.toMap());
    print("插入Word数据成功");
    return result;
  }
  // Update Operation: Update a word object and save it to database
  Future<int> updateWord(Word word) async {
    var db = await this.database;
    var result = await db.update(wordTable, word.toMap(), where: '$wordId = ?', whereArgs: [word.id]);
    print("更新Word数据成功");
    return result;
  }

  // Delete Operation: Delete a word object from database
  Future<int> deleteWord(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $wordTable WHERE $wordId = $id');
    print("删除数据成功");
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'word List' [ List<word> ]
  Future<List<Word>> getWordList() async {
    var wordMapList = await getWordMapList(); // Get 'Map List' from database
    int count = wordMapList.length;         // Count the number of map entries in db table
    List<Word> wordList = List<Word>();
    // For loop to create a 'word List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      wordList.add(Word.fromMapObject(wordMapList[i]));
    }
    return wordList;
  }
}