import 'dart:convert';

import 'package:traveltranslation/ocr/entity/user_info_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static const String KEY_SAVE_TRY_FILE = "key_has_init_file";

  static const String KEY_CONFIG = "key_val_config";
  static const String KEY_USER = "key_val_user";

  static const String KEY_USER_TOKEN = "key_user_token";
  static const String KEY_PACKAGE_NAME = "key_package_name";


  static Future<bool> saveHasInitTryFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(KEY_SAVE_TRY_FILE, true);
  }

  static Future<bool> getHasInitTryFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var name = prefs.getBool(KEY_SAVE_TRY_FILE);

    if(name == null){
      return false;
    }
    return Future.value(false);
  }

  /// 保存后台KV配置数据
  static Future<bool> saveConfigMap(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_CONFIG, data);
  }

  ///获取后台KV配置数据
  static Future<Map<String, dynamic>> getConfigMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var configData = prefs.get(KEY_CONFIG);

    if (configData != null) {
      return Future<Map<String, dynamic>>.value(json.decode(configData));
    } else {
      return Future.value(null);
    }
  }

  ///保存用户数据
  static Future<bool> saveUserMap(UserEntityInfo info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encode = json.encode(info.toJson());
    return prefs.setString(KEY_USER, encode);
  }

  ///获取用户数据
  static Future<UserEntityInfo> getUserMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userInfo = prefs.get(KEY_USER);
    if (userInfo != null) {
      var userEntityInfo = UserEntityInfo.fromJson(json.decode(userInfo));
      return Future.value(userEntityInfo);
    } else {
      return Future.value(null);
    }
  }

  ///保存用户token
  static Future<bool> saveUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_USER_TOKEN, token);
  }

  ///获取用户token
  static Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USER_TOKEN);
  }

  ///保存packageName
  static Future<bool> savePackageName(String packageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_PACKAGE_NAME, packageName);
  }

  ///获取packageName
  static Future<String> getPackageName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_PACKAGE_NAME);
  }
}
