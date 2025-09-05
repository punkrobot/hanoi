import 'package:app/data/models/move_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solution_api.g.dart';

@JsonSerializable()
class SolutionApi {
  SolutionApi(this.movesCount, this.disks, this.moves);

  final int disks;
  @JsonKey(name: 'moves_count')
  final int movesCount;
  final List<MoveApi> moves;

  factory SolutionApi.fromJson(Map<String, dynamic> json) =>
      _$SolutionApiFromJson(json);
  Map<String, dynamic> toJson() => _$SolutionApiToJson(this);
}
