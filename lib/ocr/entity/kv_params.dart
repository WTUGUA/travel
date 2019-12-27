class KVParams {
  String appid;
  String package_name;
  String sys;
  String appver;
  String lan;

  KVParams({this.appid, this.package_name, this.sys, this.appver, this.lan});

  KVParams.fromJson(Map<String, dynamic> json) {
    appid = json['appid'];
    package_name = json['package_name'];
    sys = json['sys'];
    appver = json['appver'];
    lan = json['lan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appid'] = this.appid;
    data['package_name'] = this.package_name;
    data['sys'] = this.sys;
    data['appver'] = this.appver;
    data['lan'] = this.lan;
    return data;
  }
}
