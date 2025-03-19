import 'package:flutter/material.dart';

class EmptyPlayers extends StatelessWidget {
  const EmptyPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No players found'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            child: const Text('Add Players'),
          ),
        ],
      ),
    );
  }
}
