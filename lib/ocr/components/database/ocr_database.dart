import 'package:sqflite/sqflite.dart';

import 'database_utils.dart';

final String tableOcr = "ocr_entity";

final String columnId = "_id";
final String columnTitle = "title";
final String columnContent = "content";
final String columnImages = "images";
final String columnTime = "changetime";

///Ocr识别记录实体类
class OcrDatabase {
  OcrDatabase();

  int id;
  String title;
  String content;
  String images;
  String changeTime;

  OcrDatabase.fromMap(Map map) {
    id = map[columnId] as int;
    title = map[columnTitle] as String;
    content = map[columnContent] as String;
    images = map[columnImages] as String;
    changeTime = map[columnTime] as String;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnContent: content,
      columnImages: images,
      columnTime: changeTime
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class OcrEntityProvider {
  Database db;
  Future open() async {
    String path = await DatabaseUtils.initDbName(OCR_DB_NAME);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableOcr ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnContent text not null,
  $columnImages text not null,
  $columnTime text not null)
''');
    });
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    List<Map<String, dynamic>> records = await db.query('$tableOcr');
    return records;
  }

  Future<OcrDatabase> insert(OcrDatabase ocrEntity) async {
    ocrEntity.id = await db.insert(tableOcr, ocrEntity.toMap());
    return ocrEntity;
  }

  Future<OcrDatabase> getTodo(int id) async {
    List<Map> maps = await db.query(tableOcr,
        columns: [
          columnId,
          columnTitle,
          columnContent,
          columnImages,
          columnTime
        ],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return OcrDatabase.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableOcr, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(OcrDatabase ocrEntity) async {
    return await db.update(tableOcr, ocrEntity.toMap(),
        where: "$columnId = ?", whereArgs: [ocrEntity.id]);
  }

  Future close() async => db.close();
}
