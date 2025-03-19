import 'package:flutter/material.dart';
import '../models/player_dto.dart';

class BottomControls extends StatelessWidget {
  final List<PlayerDto> selectedPlayers;

  const BottomControls({super.key, required this.selectedPlayers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Game', style: TextStyle(fontSize: 16)),
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
    );
  }
}
