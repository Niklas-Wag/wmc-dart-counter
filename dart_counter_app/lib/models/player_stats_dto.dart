class PlayerStatsDto {
  final int playerId;
  final String name;
  final int totalGames;
  final int wins;
  final double winRatio;

  PlayerStatsDto({
    required this.playerId,
    required this.name,
    required this.totalGames,
    required this.wins,
    required this.winRatio,
  });

  factory PlayerStatsDto.fromJson(Map<String, dynamic> json) {
    return PlayerStatsDto(
      playerId: json['playerId'],
      name: json['name'],
      totalGames: json['totalGames'],
      wins: json['wins'],
      winRatio:
          (json['winRatio'] is int)
              ? (json['winRatio'] as int).toDouble() * 100
              : (json['winRatio'] as double) * 100,
    );
  }
}
