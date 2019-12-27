import 'package:json_annotation/json_annotation.dart';

part 'package:traveltranslation/ocr/entity/ocr_entity.g.dart';

@JsonSerializable(nullable: false)
class OcrEntity {
  int log_id;
  int words_result_num;
  List<OcrResult> words_result;

  OcrEntity({this.log_id, this.words_result_num, this.words_result});

  factory OcrEntity.fromJson(Map<String, dynamic> json) =>
      _$OcrEntityFromJson(json);
}

@JsonSerializable(nullable: false)
class OcrResult {
  String words;

  OcrResult({this.words});

  factory OcrResult.fromJson(Map<String, dynamic> json) =>
      _$OcrResultFromJson(json);
}
