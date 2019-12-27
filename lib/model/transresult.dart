

import 'package:traveltranslation/model/word.dart';

class TransResult{
  String from;
  String to;
  List<Word> word;
  TransResult({this.from,this.to,this.word});
  factory TransResult.fromJson(Map<String, dynamic> json) {
    var list = json["trans_result"] as List;
    List<Word> word = list.map((i) => Word.fromJson(i)).toList();
    return TransResult(
        from : json["from"],
        to:json["to"],
        word : word
    );
  }
}