// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveApi _$MoveApiFromJson(Map<String, dynamic> json) => MoveApi(
  json['description'] as String,
  (json['disk'] as num).toInt(),
  json['from'] as String,
  json['to'] as String,
);

Map<String, dynamic> _$MoveApiToJson(MoveApi instance) => <String, dynamic>{
  'description': instance.description,
  'disk': instance.disk,
  'from': instance.from,
  'to': instance.to,
};
