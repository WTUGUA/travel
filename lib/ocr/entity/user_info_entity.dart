class UserEntityInfo {
  num atime;
  num viptime;
  num tel;
  String sId;
  bool vip;
  UserEntityInfoAnalysis analysis;
  bool canPay;
  UserEntityInfo(
      {this.atime, this.viptime, this.tel, this.sId, this.vip, this.analysis,this.canPay});

  UserEntityInfo.fromJson(Map<String, dynamic> json) {
    atime = json['atime'];
    viptime = json['viptime'];
    tel = json['tel'];
    sId = json['_id'];
    vip = json['vip'];
    canPay= json['can_pay'];
    analysis = json['analysis'] != null
        ? new UserEntityInfoAnalysis.fromJson(json['analysis'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['atime'] = this.atime;
    data['viptime'] = this.viptime;
    data['tel'] = this.tel;
    data['_id'] = this.sId;
    data['vip'] = this.vip;
    data['can_pay']= this.canPay;
    if (this.analysis != null) {
      data['analysis'] = this.analysis.toJson();
    }
    return data;
  }
}

class UserEntityInfoAnalysis {
  int ocrNum;
  int translateMaxNum;
  int ocrMaxNum;
  int batchMaxNum;
  bool batch;
  int batchNum;
  int translateNum;
  bool translate;
  bool ocr;

  UserEntityInfoAnalysis(
      {this.ocrNum,
      this.translateMaxNum,
      this.ocrMaxNum,
      this.batchMaxNum,
      this.batch,
      this.batchNum,
      this.translateNum,
      this.translate,
      this.ocr});

  UserEntityInfoAnalysis.fromJson(Map<String, dynamic> json) {
    ocrNum = json['ocr_num'];
    translateMaxNum = json['translate_max_num'];
    ocrMaxNum = json['ocr_max_num'];
    batchMaxNum = json['batch_max_num'];
    batch = json['batch'];
    batchNum = json['batch_num'];
    translateNum = json['translate_num'];
    translate = json['translate'];
    ocr = json['ocr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ocr_num'] = this.ocrNum;
    data['translate_max_num'] = this.translateMaxNum;
    data['ocr_max_num'] = this.ocrMaxNum;
    data['batch_max_num'] = this.batchMaxNum;
    data['batch'] = this.batch;
    data['batch_num'] = this.batchNum;
    data['translate_num'] = this.translateNum;
    data['translate'] = this.translate;
    data['ocr'] = this.ocr;
    return data;
  }
}
