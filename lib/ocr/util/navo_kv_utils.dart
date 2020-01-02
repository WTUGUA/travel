import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:traveltranslation/ocr/entity/kv_params.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:package_info/package_info.dart';

import 'md5_utils.dart';

class OnlineConfigUtils {
  static final String _serverUrl = "https://service.kv.dandanjiang.tv/remote";


  static final String batchPerNum = "batch_per_limit";


  static Map<String, dynamic> _mResponseMap = new Map();
  static bool _success = false;
  static KVParams _kvParams;
  static OnlineConfigUtils _instance;

  OnlineConfigUtils() {
    // 初始化
  }

  static OnlineConfigUtils getInstance() {
    if (_instance == null) {
      _instance = new OnlineConfigUtils();
    }
    return _instance;
  }

  Future<String> getConfigParams(String key) async {
    var responseMap = await getResponseMap();

    if(responseMap!=null){
      if (responseMap.containsKey(key)) {
        return Future.value(responseMap[key]);
      }
    }
    return Future.value("");
  }
//需要修改
  //初始化请求参数
  Future<bool> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await SpUtils.savePackageName("com.appvvv.ocr");
    _kvParams = new KVParams(
        appid: Md5Utils.generateMd5("com.appvvv.ocr"),
        package_name: "com.appvvv.ocr",
        sys: Platform.isAndroid ? "android" : "iOS",
        appver: packageInfo.version,
        lan: "CN");
    return Future<bool>.value(true);
  }

  Future<Map<String, dynamic>> getResponseMap() async {
    if (!_success) {
      await _request();
    }
    if (_mResponseMap==null||_mResponseMap.isEmpty) {
      _mResponseMap = await SpUtils.getConfigMap();
      return Future<Map<String, dynamic>>.value(_mResponseMap);
    }
    return _mResponseMap;
  }

  Future<bool> _request() async {
    if (_kvParams == null) {
      throw "OnlineConfigUtils need init!!";
    }
    var baseOptions = BaseOptions(connectTimeout: 10000, receiveTimeout: 10000);
    Dio dio = new Dio(baseOptions);
    var response =
        await dio.get(_serverUrl, queryParameters: _kvParams.toJson());
    Map<String, dynamic> jsonMap = json.decode(response.toString());
    if (jsonMap["code"] as int == 0) {
      _success = true;
      var decode = json.encode(jsonMap["res"]);
      return await SpUtils.saveConfigMap(decode);
    } else {
      return Future.value(false);
    }
  }
}
