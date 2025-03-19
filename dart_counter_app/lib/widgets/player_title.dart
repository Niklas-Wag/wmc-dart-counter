import 'package:flutter/material.dart';
import '../models/player_dto.dart';

class PlayerTile extends StatelessWidget {
  final PlayerDto player;
  final bool isSelected;
  final VoidCallback onTap;

  const PlayerTile({
    super.key,
    required this.player,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: isSelected ? Colors.blue[50] : Theme.of(context).canvasColor,
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
          onChanged: (_) => onTap(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onTap: onTap,
      ),
    );
  }
}
