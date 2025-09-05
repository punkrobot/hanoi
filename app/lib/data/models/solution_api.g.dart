// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionApi _$SolutionApiFromJson(Map<String, dynamic> json) => SolutionApi(
  (json['moves_count'] as num).toInt(),
  (json['disks'] as num).toInt(),
  (json['moves'] as List<dynamic>)
      .map((e) => MoveApi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SolutionApiToJson(SolutionApi instance) =>
    <String, dynamic>{
      'disks': instance.disks,
      'moves_count': instance.movesCount,
      'moves': instance.moves,
    };
