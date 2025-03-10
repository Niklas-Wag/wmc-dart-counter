import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSettings extends StatefulWidget {
  final Function(int, String) onSettingsChanged;

  const GameSettings({super.key, required this.onSettingsChanged});

  @override
  GameSettingsState createState() => GameSettingsState();
}

class GameSettingsState extends State<GameSettings> {
  int _points = 501;
  String _checkout = 'Double Out';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 501;
      _checkout = prefs.getString('checkout') ?? 'Double Out';
    });
    widget.onSettingsChanged(_points, _checkout);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
    await prefs.setString('checkout', _checkout);
  }

  void _onSettingsChanged(int points, String checkout) {
    setState(() {
      _points = points;
      _checkout = checkout;
      _saveSettings();
      widget.onSettingsChanged(points, checkout);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            // Use Expanded to give each column equal width.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Points', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _points,
                  items:
                      [201, 301, 501, 701]
                          .map(
                            (int value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value Points'),
                            ),
                          )
                          .toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      _onSettingsChanged(newValue, _checkout);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), // Add an outline border
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ), //Adjust padding
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16), // Add horizontal spacing between columns
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Check-out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _checkout,
                  items:
                      ['Straight Out', 'Double Out']
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _onSettingsChanged(_points, newValue);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
