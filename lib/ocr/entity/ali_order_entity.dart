class AliOrderEntity {
  String msg;
  int code;
  String data;
  String oid;

  AliOrderEntity({this.msg, this.code, this.data, this.oid});

  AliOrderEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    data = json['data'];
    oid = json['oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data;
    data['oid'] = this.oid;
    return data;
  }
}
