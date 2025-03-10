import 'package:flutter/material.dart';
import 'pages/start_game_page.dart';
import 'pages/game_page.dart';
import 'pages/settings_page.dart';
import 'pages/statistics_page.dart';

void main() {
  runApp(DartCounterApp());
}

class DartCounterApp extends StatelessWidget {
  const DartCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => StartGamePage(),
        '/game': (context) => GamePage(),
        '/settings': (context) => SettingsPage(),
        '/statistics': (context) => StatisticsPage(),
      },
    );
  }
}
