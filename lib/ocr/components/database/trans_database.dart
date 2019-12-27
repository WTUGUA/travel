import 'package:sqflite/sqflite.dart';

import 'database_utils.dart';

final String tableTrans = "trans_entity";

final String transcolumnId = "_id";
final String transcolumnTitle = "title";
final String transcolumnContent = "content";
final String transcolumnTransContent = "transcontent";
final String transcolumnImages = "images";
final String transcolumnTime = "changetime";

///Ocr识别记录实体类
class TransDatabase {
  TransDatabase();

  int id;
  String title;
  String content;
  String transcontent;
  String images;
  String changeTime;

  TransDatabase.fromMap(Map map) {
    id = map[transcolumnId] as int;
    title = map[transcolumnTitle] as String;
    content = map[transcolumnContent] as String;
    transcontent = map[transcolumnTransContent] as String;
    images = map[transcolumnImages] as String;
    changeTime = map[transcolumnTime] as String;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      transcolumnTitle: title,
      transcolumnContent: content,
      transcolumnTransContent: transcontent,
      transcolumnImages: images,
      transcolumnTime: changeTime
    };
    if (id != null) {
      map[transcolumnId] = id;
    }
    return map;
  }
}

class TransEntityProvider {
  Database db;

  Future open() async {
    String path = await DatabaseUtils.initDbName(TRANS_DB_NAME);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTrans ( 
  $transcolumnId integer primary key autoincrement, 
  $transcolumnTitle text not null,
  $transcolumnContent text not null,
  $transcolumnTransContent text not null,
  $transcolumnImages text not null,
  $transcolumnTime text not null)
''');
    });
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    List<Map<String, dynamic>> records = await db.query('$tableTrans');
    return records;
  }

  Future<TransDatabase> insert(TransDatabase transDatabase) async {
    transDatabase.id = await db.insert(tableTrans, transDatabase.toMap());
    return transDatabase;
  }

  Future<TransDatabase> getTodo(int id) async {
    List<Map> maps = await db.query(tableTrans,
        columns: [
          transcolumnId,
          transcolumnTitle,
          transcolumnContent,
          transcolumnTransContent,
          transcolumnImages,
          transcolumnTime
        ],
        where: "$transcolumnId = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TransDatabase.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableTrans, where: "$transcolumnId = ?", whereArgs: [id]);
  }

  Future<int> update(TransDatabase transDatabase) async {
    return await db.update(tableTrans, transDatabase.toMap(),
        where: "$transcolumnId = ?", whereArgs: [transDatabase.id]);
  }

  Future close() async => db.close();
}
