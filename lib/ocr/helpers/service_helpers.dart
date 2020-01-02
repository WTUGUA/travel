import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/entity/ali_order_entity.dart';
import 'package:traveltranslation/ocr/entity/analysis_entity.dart';
import 'package:traveltranslation/ocr/entity/get_user_info_entity.dart';
import 'package:traveltranslation/ocr/entity/login_entity.dart';
import 'package:traveltranslation/ocr/entity/ocr_entity.dart';
import 'package:traveltranslation/ocr/entity/trans_entity.dart';
import 'package:traveltranslation/ocr/entity/vipprice_entity.dart';
import 'package:traveltranslation/ocr/entity/wechat_order_entity.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/util/md5_utils.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';

class ServiceApi {
  static int ok = 0;

  static String serviceUrl = "https://ocr.adesk.com";

  static String ocrUrl =
      "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic";

  static String transUrl =
      "https://fanyi-api.baidu.com/api/trans/vip/translate";

  static String vipUrl = "https://vipserver.adesk.com";
//需要修改包名
  static String packageName = "com.appvvv.ocr";

  static String priavaUrl =
      "https://s.novapps.com/web_html/ocr_new_privacy.html";
  static String protocolUrl =
      "https://s.novapps.com/web_html/ocr_service_protocol.html";
  static String vipProtocolUrl =
      "https://s.novapps.com/web_html/ocr_service_protocol_vip.html";

  static String helpUrl = "https://s.novapps.com/web_html/ocr_help.html?v=3";

  //ios支付回调地址
  static String iosCallBackUrl = serviceUrl + "/v1/user/add_ios_id";
//文字识别
  static Future<TransEntity> getTransResultText(
      String originText, String transTo) async {
    var dio = new Dio(new BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded")));
    var salt = "1435660288";
    var s = Constants.appId + originText + salt + Constants.tranSecret;
    var sign = Md5Utils.generateMd5(s);
    var encoded = Uri.encodeFull(originText);
//    var encoded = Uri.encodeQueryComponent(originText);
    var request = transUrl +
        "?q=" +
        encoded +
        "&from=auto" +
        "&to=" +
        transTo +
        "&appid=" +
        Constants.appId +
        "&salt=" +
        salt +
        "&sign=" +
        sign;
    print("request$request");
    try {
      Response response = await dio.get(request);
      print(response.data.toString());
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      var transEntity = TransEntity.fromJson(jsonMap);
      return transEntity;
    } catch (e) {
      return new TransEntity(error_code: "-1", error_msg: "翻译字数过长");
    }
  }

  //通用ORC识别接口
  static Future<OcrEntity> getOrcText(String imageBase64) async {
    var dio = new Dio(new BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded")));

    FormData formData = new FormData.from({
      "image": imageBase64,
      "language_type": "CHN_ENG",
      "detect_direction": "true"
    });

    var auth = await getAuth(ak: Constants.ocr_key, sk: Constants.ocr_secret);
    if (auth != "") {
      var request = ocrUrl + "?access_token=" + auth;
      print("识别Url=" + request);
      Response response = await dio.post(request, data: formData);
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      var ocrEntity = OcrEntity.fromJson(jsonMap);
      return ocrEntity;
    }
    return null;
  }

  //ORC识别接口刷新token接口
  static Future<String> getAuth(
      {@required String ak, @required String sk, String bb}) async {
    var dio = new Dio();
    String authHost = "https://aip.baidubce.com/oauth/2.0/token?";
    String getAccessTokenUrl = authHost
        // 1. grant_type为固定参数
        +
        "grant_type=client_credentials"
        // 2. 官网获取的 API Key
        +
        "&client_id=" +
        ak
        // 3. 官网获取的 Secret Key
        +
        "&client_secret=" +
        sk;
    Response response = await dio.get(getAccessTokenUrl);
    var data = response.data;
    print(data);
    var replaceAll = data.toString().replaceAll("{", "").replaceAll("}", "");
    var split = replaceAll.split(",");
    for (int i = 0; i < split.length; i++) {
      var result = split[i].split(":");
      if (result[0].contains("access_token")) {
        print("containskey");
        return result[1];
      }
    }
    return "";
  }

  //发送验证码
  static Future<bool> sendAuth(String tel) async {
    var dio = new Dio();
    var param = {"tel": tel};
    String request = serviceUrl + "/v1/user/sendsms";
    Response response = await dio.post(request, queryParameters: param);
    Map<String, dynamic> jsonMap = json.decode(response.toString());
    if (jsonMap.containsKey("code") && jsonMap["code"] == ok) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  //用户登录
  static Future<LoginEntity> login(String tel, String code) async {
    var dio = new Dio(new BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded")));
    var platform = getPlatform();
    var map = {"tel": tel, "code": code, "platform": platform};
    var request = serviceUrl + "/v1/user/login";
    var response = await dio.post(request, data: map);
    var decode = json.decode(response.data);
    var loginEntity = LoginEntity.fromJson(decode);
    if (loginEntity.code == ok) {
      //保存token 和用户数据
      await SpUtils.saveUserToken(loginEntity.res.token);
      print("登录成功最大max${loginEntity.res.info.analysis.batchMaxNum}");
      await SpUtils.saveUserMap(loginEntity.res.info);
      if (loginEntity.res.info.vip) {
        //VIP用户
        UserDelegate.userStatus = UserStatus.VIP;
      } else {
        //普通用户
        UserDelegate.userStatus = UserStatus.GENERAL;
      }
    }
    return Future<LoginEntity>.value(loginEntity);
  }

  //获取用户信息
  static Future<GetUserInfoEntity> getUserInfo(String token) async {
    var dio = new Dio(new BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded")));
    var platform = getPlatform();
    FormData formData =
        new FormData.from({"token": token, "platform": platform});
    var request = serviceUrl + "/v1/user/info";
    var response = await dio.post(request, data: formData);
    Map<String, dynamic> jsonMap = json.decode(response.toString());

    var getUserInfoEntity = GetUserInfoEntity.fromJson(jsonMap);
    if (getUserInfoEntity.code == ok) {
      await SpUtils.saveUserMap(getUserInfoEntity.res);
    } else {
      await SpUtils.saveUserToken("");
    }
    return Future<GetUserInfoEntity>.value(getUserInfoEntity);
  }

  //记录统计数据
  static Future<AnalysisEntity> analysis(String token, String type) async {
    var dio = new Dio(new BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded")));
    var formData = new FormData.from({
      "token": token,
      "type": type,
    });
    String request = serviceUrl + "/v1/user/analysis";
    Response response = await dio.post(request, data: formData);
    Map<String, dynamic> jsonMap = json.decode(response.toString());
    var analysisEntity = AnalysisEntity.fromJson(jsonMap);
    return Future.value(analysisEntity);
  }

  //加载VIP价格表
  static Future<VipPriceEntity> getVipPrices() async {
    String request = vipUrl + "/v1/price/list";
    String packageName = "com.appvvv.ocr";
    String platform = Platform.isAndroid ? "android" : "iOS";
    var params = {"platform": platform, "package": packageName};

    var dio = new Dio();
    Response response = await dio.get(request, queryParameters: params);
    var vipPriceEntity = VipPriceEntity.fromJson(response.data);
    print(vipPriceEntity);
    return Future.value(vipPriceEntity);
  }

  //拉取支付宝订单
  static Future<AliOrderEntity> getAliOrder(
      String priceId, String userId) async {
    String request = vipUrl + "/v1/alipay/sign";
    String platform = Platform.isAndroid ? "android" : "iOS";
    var params = {
      "platform": platform,
      "package": packageName,
      "openid": userId,
      "subject": "旅行翻译器VIP服务",
      "price_id": priceId
    };
    var dio = new Dio();
    Response response = await dio.get(request, queryParameters: params);
    var aliOrderEntity = AliOrderEntity.fromJson(response.data);
    return Future<AliOrderEntity>.value(aliOrderEntity);
  }

  //拉取微信订单
  static Future getWeChatOrder(String priceId, String userId) async {
    String request = vipUrl + "/v1/wechat/sign";
    String platform = Platform.isAndroid ? "android" : "iOS";
    var params = {
      "platform": platform,
      "package": packageName,
      "openid": userId,
      "subject": "旅行翻译器VIP服务",
      "price_id": priceId
    };
    var dio = new Dio();
    Response response = await dio.get(request, queryParameters: params);
    var wechatOrderEntity = WechatOrderEntity.fromJson(response.data);
    return Future.value(wechatOrderEntity);
  }

  // ios 绑定original_transaction_id
  static Future setOriginalTransactionId(
      String token, String originalTransactionId) async {
    String request = serviceUrl + "/v1/user/add_ios_id";

    var dio = new Dio(new BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded")));
    FormData formData = new FormData.from({
      "original_transaction_id": originalTransactionId,
      "token": token,
    });
    Response response = await dio.post(request, data: formData);
    var decode = json.decode(response.data);
    return Future.value(true);
  }

  static String getPlatform() {
    var platform = "android";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }
    return platform;
  }
}
