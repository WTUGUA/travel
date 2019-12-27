import 'package:json_annotation/json_annotation.dart';

part 'package:traveltranslation/ocr/entity/trans_entity.g.dart';

@JsonSerializable(nullable: false)
class TransEntity {
//  {from: zh, to: en, trans_result: [{src: 你们好 我们在这里测试翻译功能, dst: Hello, we are here to test the translation function.}]}

  final String from;
  final String to;
  final String error_code;
  final String error_msg;
  List<TransResult> trans_result;

  TransEntity(
      {this.from, this.to, this.trans_result, this.error_code, this.error_msg});

  factory TransEntity.fromJson(Map<String, dynamic> json) =>
      _$TransEntityFromJson(json);
}

@JsonSerializable(nullable: false)
class TransResult {
  String src;
  String dst;

  TransResult({this.src, this.dst});

  factory TransResult.fromJson(Map<String, dynamic> json) =>
      _$TransResultFromJson(json);
}
