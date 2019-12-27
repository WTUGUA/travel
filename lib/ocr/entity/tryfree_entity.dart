class TryFreeEntity {
  int ocrNum;
  int batchNum;
  int translateNum;

  TryFreeEntity({this.ocrNum, this.batchNum, this.translateNum});

  TryFreeEntity.fromJson(Map<String, dynamic> json) {
    ocrNum = json['ocr_num'];
    batchNum = json['batch_num'];
    translateNum = json['translate_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ocr_num'] = this.ocrNum;
    data['batch_num'] = this.batchNum;
    data['translate_num'] = this.translateNum;
    return data;
  }
}
