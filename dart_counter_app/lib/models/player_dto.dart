class PlayerDto {
  final int? id;
  final String? name;

  PlayerDto({this.id, this.name});

  factory PlayerDto.fromJson(Map<String, dynamic> json) {
    return PlayerDto(id: json['id'], name: json['name']);
  }
}
