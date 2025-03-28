import 'package:dart_counter_app/models/dart_throw.dart';
import 'package:flutter/material.dart';

class ThrowDisplay extends StatelessWidget {
  final List<DartThrow?> selectedThrows;

  const ThrowDisplay({super.key, required this.selectedThrows});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            selectedThrows
                .map(
                  (e) => Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        e != null ? e.display : '',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
