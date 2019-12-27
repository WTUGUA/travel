import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';

/// desc:用户身份：游客，普通用户，VIP用户
enum UserStatus { GUEST, GENERAL, VIP }

class UserDelegate {
  static UserStatus userStatus = UserStatus.GUEST;

  static UserStatus getUserState() {
    return userStatus;
  }

  bool isVip() {
    return userStatus == UserStatus.VIP;
  }

  //刷新UserInfo
  static Future getUserInfo() async {
    var token = await SpUtils.getUserToken();
    if (token != null && token.isNotEmpty) {
      var userInfo = await ServiceApi.getUserInfo(token);
      if (userInfo.code == 0) {
        //刷新保存的userinfo
        if (userInfo.res.vip) {
          userStatus = UserStatus.VIP;
        } else {
          userStatus = UserStatus.GENERAL;
        }
      } else {
        //TOKEN过期删除token
        userStatus = UserStatus.GUEST;
      }
    }
  }

  //退出当前账号
  static Future quitCurrentAccount() async {
    //删除token
    var token = await SpUtils.saveUserToken("");
    //用户状态返回为游客
    userStatus = UserStatus.GUEST;
  }
}
