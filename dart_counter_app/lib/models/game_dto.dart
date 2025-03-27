import 'package:dart_counter_app/models/game_result_dto.dart';

class GameDto {
  final List<GameResultDto>? results;

  GameDto({this.results});

  factory GameDto.fromJson(Map<String, dynamic> json) {
    var resultsJson = json['results'] as List?;
    List<GameResultDto>? results =
        resultsJson
            ?.map((resultJson) => GameResultDto.fromJson(resultJson))
            .toList();

    return GameDto(results: results);
  }

  Map<String, dynamic> toJson() {
    return {'results': results?.map((result) => result.toJson()).toList()};
  }
}
