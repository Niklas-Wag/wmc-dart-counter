import 'package:flutter/material.dart';
import '../models/player_dto.dart';
import 'player_title.dart';

class PlayerList extends StatelessWidget {
  final List<PlayerDto> players;
  final List<PlayerDto> selectedPlayers;
  final ValueChanged<List<PlayerDto>> onSelectionChanged;

  const PlayerList({
    super.key,
    required this.players,
    required this.selectedPlayers,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: players.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return PlayerTile(
          player: players[index],
          isSelected: selectedPlayers.contains(players[index]),
          onTap: () {
            List<PlayerDto> updatedList = List.from(selectedPlayers);
            if (updatedList.contains(players[index])) {
              updatedList.remove(players[index]);
            } else {
              updatedList.add(players[index]);
            }
            onSelectionChanged(updatedList);
          },
        );
      },
    );
  }
}
