// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransEntity _$TransEntityFromJson(Map<String, dynamic> json) {
  return TransEntity(
    from: json['from'] as String,
    to: json['to'] as String,
    error_code: json['error_code'] as String,
    error_msg: json['error_msg'] as String,
    trans_result: (json['trans_result'] as List)
        .map((e) => TransResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TransEntityToJson(TransEntity instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'trans_result': instance.trans_result,
    };

TransResult _$TransResultFromJson(Map<String, dynamic> json) {
  return TransResult(
    src: json['src'] as String,
    dst: json['dst'] as String,
  );
}

Map<String, dynamic> _$TransResultToJson(TransResult instance) =>
    <String, dynamic>{
      'src': instance.src,
      'dst': instance.dst,
    };
