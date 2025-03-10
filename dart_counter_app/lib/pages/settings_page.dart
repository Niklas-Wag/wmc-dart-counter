import 'package:dart_counter_app/models/player_dto.dart';
import 'package:dart_counter_app/services/api_service.dart';
import 'package:dart_counter_app/widgets/game_settings.dart';
import 'package:dart_counter_app/widgets/settings_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  List<PlayerDto> players = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      players = await _apiService.fetchPlayers();
      setState(() {});
    } catch (e) {
      _showSnackBar('Failed to load players: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onGameSettingsChanged(int points, String checkout) {
    _saveSettings(points, checkout);
  }

  Future<void> _saveSettings(int points, String checkout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', points);
    await prefs.setString('checkout', checkout);
  }

  Future<void> _addPlayer(String playerName) async {
    try {
      await _apiService.addPlayer(playerName);
      _fetchPlayers();
    } catch (e) {
      _showSnackBar('Failed to add player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        forceMaterialTransparency: true,
      ), //),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsList(
              players: players,
              onPlayersUpdated: _fetchPlayers,
              onAddPlayer: _addPlayer,
            ),
            const SizedBox(height: 24),
            GameSettings(onSettingsChanged: _onGameSettingsChanged),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
