class VipPriceEntity {
  String msg;
  int code;
  List<VipPriceData> data;

  VipPriceEntity({this.msg, this.code, this.data});

  VipPriceEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = new List<VipPriceData>();
      (json['data'] as List).forEach((v) {
        data.add(new VipPriceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VipPriceData {
  String price;
  String days;
  String originPrice;
  String id;
  String type;
  String appId;
  dynamic desc;

  VipPriceData(
      {this.price,
      this.days,
      this.originPrice,
      this.id,
      this.type,
      this.appId,
      this.desc});

  VipPriceData.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    days = json['days'];
    originPrice = json['origin_price'];
    id = json['id'];
    type = json['type'];
    appId = json['app_id'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['days'] = this.days;
    data['origin_price'] = this.originPrice;
    data['id'] = this.id;
    data['type'] = this.type;
    data['app_id'] = this.appId;
    data['desc'] = this.desc;
    return data;
  }
}
