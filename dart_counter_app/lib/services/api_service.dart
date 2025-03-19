import 'dart:convert';
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
}
