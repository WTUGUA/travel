import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String OCR_DB_NAME = "ocr.db";
const String TRANS_DB_NAME = "trans.db";

class DatabaseUtils {
// return the path
  static Future<String> initDbName(String dbName) async {
    final String databasePath = await getDatabasesPath();
    // print(databasePath);
    final String path = join(databasePath, dbName);

    // make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
//      await deleteDatabase(path);
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }
}
