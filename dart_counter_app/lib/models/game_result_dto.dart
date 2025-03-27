class GameResultDto {
  final int playerId;
  final bool isWinner;

  GameResultDto({required this.playerId, required this.isWinner});

  factory GameResultDto.fromJson(Map<String, dynamic> json) {
    return GameResultDto(
      playerId: json['playerId'] as int,
      isWinner: json['isWinner'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'playerId': playerId, 'isWinner': isWinner};
  }
}
