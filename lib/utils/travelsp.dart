import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveltranslation/model/select.dart';

class TravelSP{
  static const String KEY_Privacy = "key_Privacy";
  static const String KEY_From = "key_From";
  static const String KEY_To = "key_To";
  static const String KEY_From_Value = "key_From_Value";
  static const String KEY_To_Value = "key_To_Value";
  static const String KEY_Ocr_Time = "key_Ocr_Time";
  static const String KEY_Time="Key_Time";
  static const String KEY_TR_Time="Key_Tr_Time";
  static const String KEY_Code="Key_Code";
  static const String KEY_CONFIG = "key_val_config";
  ///保存隐私弹窗
  static Future<bool> savePrivacy(bool token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(KEY_Privacy, token);
  }

  ///保存隐私弹窗
  static Future<bool> getPrivacy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool privacy=prefs.getBool(KEY_Privacy);
    if(privacy==null){
      return false;
    }else{
      return privacy;
    }
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
  ///保存的尝试次数
  static Future<bool> saveOcrTime(int ocrtime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(KEY_Ocr_Time, ocrtime);
  }

  ///获取保存的尝试次数
  static Future<int> getOcrTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int ocrtime=prefs.getInt(KEY_Ocr_Time);
    if(ocrtime==null){
      return 0;
    }else{
      return ocrtime;
    }
  }
//  ///保存时间
//  static Future<bool> saveTime(String to) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.setString(KEY_Time, to);
//
//  }
//
//  ///获取保存的时间
//  static Future<String> getTime() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String time=prefs.getString(KEY_Time);
//    if(time==null){
//      print("time=$time");
//      return null;
//    }else {
//      return prefs.getString(KEY_Time);
//    }
//  }
  ///保存时间
  static Future<bool> saveTRTime(int to) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(KEY_TR_Time, to);

  }

  ///获取保存的时间
  static Future<int> getTRTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int time=prefs.getInt(KEY_TR_Time);
    if(time==null){
      return 0;
    }else {
      return prefs.getInt(KEY_TR_Time);
    }
  }
  ///保存版本
  static Future<bool> saveCode(int to) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(KEY_Code, to);
  }

  ///获取保存的版本
  static Future<int> getCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int time=prefs.getInt(KEY_Code);
    if(time==null){
      return 1;
    }else {
      return prefs.getInt(KEY_Code);
    }
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
}