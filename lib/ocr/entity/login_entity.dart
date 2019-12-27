import 'package:traveltranslation/ocr/entity/user_info_entity.dart';

class LoginEntity {
  dynamic msg;
  LoginEntityRes res;
  int code;

  LoginEntity({this.msg, this.res, this.code});

  LoginEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    res = json['res'] != null ? new LoginEntityRes.fromJson(json['res']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.res != null) {
      data['res'] = this.res.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class LoginEntityRes {
  String token;
  UserEntityInfo info;

  LoginEntityRes({this.token, this.info});

  LoginEntityRes.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    info =
        json['info'] != null ? new UserEntityInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    return data;
  }
}
