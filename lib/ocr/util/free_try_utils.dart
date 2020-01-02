import 'dart:convert';
import 'dart:io';

import 'package:device_id/device_id.dart';
import 'package:traveltranslation/ocr/entity/tryfree_entity.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:nova_utils/nova_utils.dart';

class TryUtils {
  static var filename = "";
  static var tryFreeEntity;

  //init
  static void init() async {
    if (Platform.isAndroid) {
      await initAndroid();
    } else if (Platform.isIOS) {
      await initIOS();
    }
  }

  static Future initAndroid() async {
    await initTryFileName();
    File file = new File(filename);
    var exist = await file.exists();
    print("测试exist："+exist.toString());
    var hasInitFile = await SpUtils.getHasInitTryFile();
    print("测试sp值hasInitFile："+hasInitFile.toString());
    if (!exist && !hasInitFile) {
      //初始化授权文件次数
      file.createSync();
      //默认使用了0次
      //应用新建初始化
      tryFreeEntity = new TryFreeEntity(batchNum: 0, ocrNum: 0, translateNum: 0);
      var encode = json.encode(tryFreeEntity);
      await file.writeAsString(encode);
      await SpUtils.saveHasInitTryFile();
    } else {
      print("用户试用授权文件存在");
      tryFreeEntity = await _getTryFileContent();
    }
  }
//根据用户ID存储试用数据到本地
  static Future initTryFileName() async {
    var uuid = await DeviceId.getID;
    if (Platform.isAndroid) {
      var platPath = "/storage/emulated/0/";
      filename = platPath + "$uuid.txt";
    }
  }

  static Future<TryFreeEntity> _getTryFileContent() async {
    if (filename.isNotEmpty) {
      File file = new File(filename);
      var s = await file.readAsString();
      if (s != null && s.isNotEmpty) {
        var decode = json.decode(s);
        var tryFreeEntity = TryFreeEntity.fromJson(decode);
        return Future.value(tryFreeEntity);
      }
      return Future.value(null);
    } else {
      return Future.value(null);
    }
  }

  static Future<bool> writTryFileContent(TryFreeEntity tryFreeEntity) async {

    TryUtils.tryFreeEntity = tryFreeEntity;
    if(Platform.isAndroid){
      if (filename.isNotEmpty) {
        File file = new File(filename);
        var encode = json.encode(tryFreeEntity);
        await file.writeAsString(encode);
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    }else if(Platform.isIOS){
      Map<String, String> iosCountFIle = {
        "batchNum": tryFreeEntity.batchNum.toString(),
        "ocrNum": tryFreeEntity.ocrNum.toString(),
        "translateNum": tryFreeEntity.translateNum.toString(),
      };
      await NovaUtils.setKeyChanValue(iosCountFIle);
      return Future.value(true);
    }

    return Future.value(true);
  }

  static Future<void> initIOS() async {
    //默认使用了0次
    List<String> paramName = ["batchNum", "ocrNum", "translateNum"];
    //获取IOS设置钥匙链的值
    Map<String, String> data = await NovaUtils.getKeyChainValue(paramName);
    if(data!=null){
      //如果返回key，则视作保存过,否则保存init次数
      if (data.containsKey("batchNum") &&
          data.containsKey("ocrNum") &&
          data.containsKey("translateNum")) {
        var batchNum = int.parse(data["batchNum"]);
        var ocrNum = int.parse(data["ocrNum"]);
        var translateNum = int.parse(data["translateNum"]);
        tryFreeEntity = new TryFreeEntity(
            batchNum: batchNum, ocrNum: ocrNum, translateNum: translateNum);
      }
    } else {
      clearIosKey();
    }
  }
  static void clearIosKey() async{
    Map<String, String> iosCountFIle = {
      "batchNum": "0",
      "ocrNum": "0",
      "translateNum": "0",
    };
    await NovaUtils.setKeyChanValue(iosCountFIle);
    tryFreeEntity =
    new TryFreeEntity(batchNum: 0, ocrNum: 0, translateNum: 0);
    print("使用次数清零");
  }
}
