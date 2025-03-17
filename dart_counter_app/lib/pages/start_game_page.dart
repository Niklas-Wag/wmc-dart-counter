import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player_dto.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  StartGamePageState createState() => StartGamePageState();
}

class StartGamePageState extends State<StartGamePage>
    with WidgetsBindingObserver {
  final ApiService apiService = ApiService();
  List<PlayerDto> players = [];
  List<PlayerDto> selectedPlayers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchPlayers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _fetchPlayers() async {
    try {
      final fetchedPlayers = await apiService.fetchPlayers();
      setState(() => players = fetchedPlayers);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading players: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  '/settings',
                ).then((_) => _fetchPlayers()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Participants (${selectedPlayers.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          Expanded(
            child:
                players.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.group_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text('No players found'),
                          TextButton(
                            onPressed:
                                () => Navigator.pushNamed(context, '/settings'),
                            child: const Text('Add Players'),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: players.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final isSelected = selectedPlayers.contains(player);
                        return Card(
                          elevation: 1,
                          color:
                              isSelected
                                  ? Colors.blue[50]
                                  : Theme.of(context).canvasColor,
                          child: ListTile(
                            title: Text(
                              player.name ?? 'Unknown Player',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged:
                                  (value) => setState(
                                    () =>
                                        value!
                                            ? selectedPlayers.add(player)
                                            : selectedPlayers.remove(player),
                                  ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onTap:
                                () => setState(
                                  () =>
                                      isSelected
                                          ? selectedPlayers.remove(player)
                                          : selectedPlayers.add(player),
                                ),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'Start Game',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed:
                        selectedPlayers.isEmpty
                            ? null
                            : () => Navigator.pushNamed(
                              context,
                              '/game',
                              arguments: selectedPlayers,
                            ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/statistics'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.leaderboard, size: 18),
                      SizedBox(width: 8),
                      Text('View Statistics'),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
