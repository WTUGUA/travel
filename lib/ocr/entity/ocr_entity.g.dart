// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OcrEntity _$OcrEntityFromJson(Map<String, dynamic> json) {
  return OcrEntity(
    log_id: json['log_id'] as int,
    words_result_num: json['words_result_num'] as int,
    words_result: (json['words_result'] as List)
        .map((e) => OcrResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OcrEntityToJson(OcrEntity instance) => <String, dynamic>{
      'log_id': instance.log_id,
      'words_result_num': instance.words_result_num,
      'words_result': instance.words_result,
    };

OcrResult _$OcrResultFromJson(Map<String, dynamic> json) {
  return OcrResult(
    words: json['words'] as String,
  );
}

Map<String, dynamic> _$OcrResultToJson(OcrResult instance) => <String, dynamic>{
      'words': instance.words,
    };
