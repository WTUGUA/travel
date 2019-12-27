import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveltranslation/model/select.dart';

class TravelSP{
  static const String KEY_Privacy = "key_package_name";
  static const String KEY_From = "key_From";
  static const String KEY_To = "key_To";
  static const String KEY_From_Value = "key_From_Value";
  static const String KEY_To_Value = "key_To_Value";
  ///保存用户token
  static Future<bool> savePrivacy(bool token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(KEY_Privacy, token);
  }

  ///获取用户token
  static Future<bool> getPrivacy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_Privacy);
  }
  ///保存的源语言值
  static Future<bool> saveFrom(String from) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_From, from);
  }

  ///获取保存的源语言值
  static Future<String> getFrom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_From);
  }
  ///保存的目标语言值
  static Future<bool> saveTo(String to) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_To, to);
  }

  ///获取保存的目标语言值
  static Future<String> getTo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_To);
  }
  ///保存的源语言值
  static Future<bool> saveFromValue(String from) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_From_Value, from);
  }

  ///获取保存的源语言值
  static Future<String> getFromValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_From_Value);
  }
  ///保存的目标语言值
  static Future<bool> saveToValue(String to) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_To_Value, to);
  }

  ///获取保存的目标语言值
  static Future<String> getToValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_To_Value);
  }
}