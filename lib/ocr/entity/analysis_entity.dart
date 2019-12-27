import 'package:traveltranslation/ocr/entity/user_info_entity.dart';

class AnalysisEntity {
  dynamic msg;
  UserEntityInfo res;
  int code;

  AnalysisEntity({this.msg, this.res, this.code});

  AnalysisEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    res = json['res'] != null ? new UserEntityInfo.fromJson(json['res']) : null;
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
