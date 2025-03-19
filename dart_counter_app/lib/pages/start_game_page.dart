import 'package:dart_counter_app/widgets/empty_players.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player_dto.dart';
import '../widgets/player_list.dart';
import '../widgets/bottom_controls.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  StartGamePageState createState() => StartGamePageState();
}

class StartGamePageState extends State<StartGamePage> {
  final ApiService apiService = ApiService();
  List<PlayerDto> players = [];
  List<PlayerDto> selectedPlayers = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      final fetchedPlayers = await apiService.fetchPlayers();
      setState(() {
        players = fetchedPlayers;
      });
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
                    ? const EmptyPlayers()
                    : PlayerList(
                      players: players,
                      selectedPlayers: selectedPlayers,
                      onSelectionChanged: (updatedList) {
                        setState(() => selectedPlayers = updatedList);
                      },
                    ),
          ),
          BottomControls(selectedPlayers: selectedPlayers),
        ],
      ),
    );
  }
}
