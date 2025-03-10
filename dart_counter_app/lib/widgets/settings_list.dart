import 'package:flutter/material.dart';
import '../models/player_dto.dart';
import '../services/api_service.dart';

class SettingsList extends StatefulWidget {
  final List<PlayerDto> players;
  final Function onPlayersUpdated;
  final Function(String) onAddPlayer;

  const SettingsList({
    super.key,
    required this.players,
    required this.onPlayersUpdated,
    required this.onAddPlayer,
  });

  @override
  SettingsListState createState() => SettingsListState();
}

class SettingsListState extends State<SettingsList> {
  final ApiService _apiService = ApiService();

  Future<void> _deletePlayer(int playerId) async {
    try {
      await _apiService.deletePlayer(playerId);
      widget.onPlayersUpdated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  void _showAddPlayerDialog(BuildContext context) {
    String playerName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Player'),
          content: TextField(
            onChanged: (value) => playerName = value,
            decoration: const InputDecoration(hintText: 'Player Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (playerName.isNotEmpty) {
                  widget.onAddPlayer(playerName); // Use the passed function
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Players', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddPlayerDialog(context),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                widget.players.isEmpty
                    ? Center(
                      child: Text(
                        'No players added yet.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ) // Show a message when empty
                    : ListView.separated(
                      itemCount: widget.players.length,
                      separatorBuilder:
                          (context, index) =>
                              const Divider(height: 1), // Add a divider
                      itemBuilder: (context, index) {
                        final player = widget.players[index];
                        return ListTile(
                          title: Text(player.name ?? 'Unknown'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deletePlayer(player.id!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
