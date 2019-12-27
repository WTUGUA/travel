import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:nova_utils/generated/i18n.dart';

import './route_handlers.dart';

class Routes {
  static Router router;
  static String root = "/";
  static String home = "/home";


  static String showPicture = "/show";
  static String setting = "/setting";
  static String settingLogin = "/setting/login";
  static String settingHelp = "/setting/help";

  static String history = "/history";

  static String vip = "vip";

  static String webView = '/webview';
  static String mainPage="/mainview";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return null;
    });
    router.define(mainPage, handler: mainHandler);
    router.define(root, handler: rootHandler);
    router.define(home, handler: homeHandler);
    router.define(showPicture, handler: showPictureHandler);
    router.define(setting, handler: settingHandler);
    router.define(settingLogin, handler: loginHandler);
    router.define(settingHelp, handler: helpHandler);
    router.define(vip, handler: vipHandler);
    router.define(history, handler: historyHandler);
    router.define(webView, handler: webViewHandler);
  }
}
