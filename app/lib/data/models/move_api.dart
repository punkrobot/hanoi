import 'package:json_annotation/json_annotation.dart';

part 'move_api.g.dart';

@JsonSerializable()
class MoveApi {
  final String description;
  final int disk;
  final String from;
  final String to;

  MoveApi(this.description, this.disk, this.from, this.to);

  factory MoveApi.fromJson(Map<String, dynamic> json) =>
      _$MoveApiFromJson(json);
  Map<String, dynamic> toJson() => _$MoveApiToJson(this);
}
