import 'package:dart_counter_app/models/player_dto.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments passed during navigation.
    final List<PlayerDto?> playerNames =
        ModalRoute.of(context)?.settings.arguments as List<PlayerDto?>;

    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (playerNames.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: playerNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(playerNames[index]?.name ?? 'Unknown'),
                    );
                  },
                ),
              ),
            ] else if (playerNames.isEmpty) ...[
              const SizedBox(height: 20),
              const Text('No players were selected.'),
            ] else ...[
              const SizedBox(height: 20),
              const Text('Players data not available.'),
            ],
          ],
        ),
      ),
    );
  }
}
