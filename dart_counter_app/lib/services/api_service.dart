import 'dart:convert';
import 'package:dart_counter_app/models/game_dto.dart';
import 'package:dart_counter_app/models/game_result_dto.dart';
import 'package:dart_counter_app/models/player_stats_dto.dart';
import 'package:http/http.dart' as http;
import '../models/player_dto.dart';

class ApiService {
  final String apiUrl = 'http://10.0.2.2:5000/api';

  Future<List<PlayerDto>> fetchPlayers() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/Players'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PlayerDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load players: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addPlayer(String playerName) async {
    final response = await http.post(
      Uri.parse('$apiUrl/Players?name=$playerName'),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to add player: ${response.statusCode}');
    }
  }

  Future<void> deletePlayer(int playerId) async {
    final response = await http.delete(Uri.parse('$apiUrl/Players/$playerId'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete player: ${response.statusCode}');
    }
  }

  Future<List<PlayerStatsDto>> fetchPlayerStats() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/Games/players-stats'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PlayerStatsDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load player stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> postGameResult(List<GameResultDto> results) async {
    try {
      final gameDto = GameDto(results: results);
      final response = await http.post(
        Uri.parse('$apiUrl/Games'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(gameDto.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to post game result: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error posting game result: $e');
    }
  }
}
