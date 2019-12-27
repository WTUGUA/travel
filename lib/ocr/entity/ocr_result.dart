class RecoResult {
  int returnCode;
  String returnMsg;
  int errorCode;
  String errorMsg;

  RecoResult({this.returnCode, this.returnMsg, this.errorCode, this.errorMsg});

  RecoResult.fromJson(Map<String, dynamic> json) {
    returnCode = json['returnCode'];
    returnMsg = json['returnMsg'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnCode'] = this.returnCode;
    data['returnMsg'] = this.returnMsg;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}
