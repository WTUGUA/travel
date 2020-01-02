
import 'package:camera/camera.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/components/setting/login_component.dart';
import 'package:traveltranslation/ocr/components/setting/widgets/loginwithvip_component.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/page/login/privacy.dart';
import 'package:traveltranslation/page/login/splash.dart';
import 'package:traveltranslation/utils/travelsp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ocr/config/application.dart';
import 'ocr/config/routes.dart';
import 'ocr/util/free_try_utils.dart';


//void main() => runApp(MyApp(
//
//));
List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  String first=await TravelSP.getFromValue();
  requestPermiss();
  final router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  UserDelegate.getUserInfo();
  //初始化线上配置
  OnlineConfigUtils.getInstance().init();
  //初始化umeng
  EventUtil.init();
  print(first);
  if(first==null){
//    TravelSP.savePrivacy(false);
  TravelSP.saveFrom("简体中文");
  TravelSP.saveFromValue("zh");
  TravelSP.saveTo("英语");
  TravelSP.saveToValue("en");
  print("保存默认值");
  runApp(MyApp());
  }else {
    runApp(MyApp());
  }
}
requestPermiss() async {
  //请求权限
  Map<PermissionGroup, PermissionStatus> permissions =
  await PermissionHandler()
      .requestPermissions([PermissionGroup.storage,PermissionGroup.camera]);
  //校验权限
  if(permissions[PermissionGroup.camera] != PermissionStatus.granted){
    print("无照相权限");
  }
  if(permissions[PermissionGroup.storage] != PermissionStatus.granted){
    print("无读取内存权限");
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sqflite demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home:
      //LoginComponent(),
       Splash(),
      // Privacy(),
    );
  }
}