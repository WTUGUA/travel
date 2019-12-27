class WechatOrderEntity {
	String msg;
	int code;
	WechatOrderData data;
	String oid;

	WechatOrderEntity({this.msg, this.code, this.data, this.oid});

	WechatOrderEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new WechatOrderData.fromJson(json['data']) : null;
		oid = json['oid'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['oid'] = this.oid;
		return data;
	}
}

class WechatOrderData {
	String package;
	String appid;
	String sign;
	String partnerid;
	String prepayid;
	String noncestr;
	int timestamp;

	WechatOrderData({this.package, this.appid, this.sign, this.partnerid, this.prepayid, this.noncestr, this.timestamp});

	WechatOrderData.fromJson(Map<String, dynamic> json) {
		package = json['package'];
		appid = json['appid'];
		sign = json['sign'];
		partnerid = json['partnerid'];
		prepayid = json['prepayid'];
		noncestr = json['noncestr'];
		timestamp = json['timestamp'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['package'] = this.package;
		data['appid'] = this.appid;
		data['sign'] = this.sign;
		data['partnerid'] = this.partnerid;
		data['prepayid'] = this.prepayid;
		data['noncestr'] = this.noncestr;
		data['timestamp'] = this.timestamp;
		return data;
	}
}
