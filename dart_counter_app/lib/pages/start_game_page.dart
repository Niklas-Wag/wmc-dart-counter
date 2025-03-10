import 'package:flutter/material.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  StartGamePageState createState() => StartGamePageState();
}

class StartGamePageState extends State<StartGamePage> {
  List<String> selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dart Counter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        // Center the button
        child: ElevatedButton(
          onPressed:
              () => Navigator.pushNamed(
                context,
                '/game',
                arguments: selectedPlayers,
              ),
          child: Text('Start Game'),
        ),
      ),
    );
  }
}
