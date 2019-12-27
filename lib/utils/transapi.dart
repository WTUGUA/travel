import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'md5.dart';

class TransApi {
  static final String _TRANS_API_HOST =
      "https://fanyi-api.baidu.com/api/trans/vip/translate";

  String _appid;
  String _securityKey;

  TransApi(String appid, String securityKey) {
    _appid = appid;
    _securityKey = securityKey;
  }

  String getTransResult(String query, String from, String to) {
    Map<String, String> params = buildParams(query, from, to);
    //HTTP请求
    var url = 'https://fanyi-api.baidu.com/api/trans/vip/translate' + '?q=' + query +
        '&from=' + from + '&to=' + to + '&appid=' + _appid + '&salt=1435660288&sign='+ _securityKey+ '';
    getresult(url);
    return url;
  }

  Map<String, String> buildParams(String query, String from, String to) {
    Map<String, String> params = new HashMap<String, String>();
    params["q"]= query;
    params["from"]=from;
    params["to"]=to;
    params["appid"]=_appid;
// 随机数
    String salt='1435660288';
    params["salt"]=salt;
// 签名
    String src = _appid + query + salt + _securityKey; // 加密前的原文
    params["sign"]=generateMd5(src);
    return params;
  }
  void getresult(String url) async{
    try {
      //实例化一个HttpClient对象
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      var result = await response.transform(utf8.decoder).join();
      print(result);
      httpClient.close();
    }catch(e){
      print("请求失败:$e");
    }finally{

    }
  }
}
