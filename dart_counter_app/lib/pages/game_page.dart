import 'dart:math';
import 'package:dart_counter_app/models/dart_throw.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_counter_app/models/game_result_dto.dart';
import 'package:dart_counter_app/services/api_service.dart';
import 'package:dart_counter_app/models/player_dto.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<PlayerDto> players;
  late List<int> remainingPoints;
  int currentPlayerIndex = 0;
  List<DartThrow?> selectedThrows = [null, null, null];
  int multiplier = 1;
  final Random _random = Random();

  int _initialPoints = 501;
  String _checkoutType = 'Double Out';
  bool _isLoaded = false;

  late List<GlobalKey> playerKeys;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      await _loadSettingsAndPlayers();
    }
  }

  Future<void> _loadSettingsAndPlayers() async {
    final List<PlayerDto?> playerData =
        ModalRoute.of(context)?.settings.arguments as List<PlayerDto?>;

    final prefs = await SharedPreferences.getInstance();
    final points = prefs.getInt('points') ?? 501;
    final checkout = prefs.getString('checkout') ?? 'Double Out';

    if (!mounted) return;

    players = playerData.whereType<PlayerDto>().toList();
    players.shuffle(_random);

    playerKeys = List.generate(players.length, (index) => GlobalKey());

    setState(() {
      _initialPoints = points;
      _checkoutType = checkout;
      remainingPoints = List.filled(players.length, points);
      _isLoaded = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentPlayer();
    });
  }

  void _scrollToCurrentPlayer() {
    final currentKey = playerKeys[currentPlayerIndex];
    final context = currentKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  String _getThrowDisplay(DartThrow dartThrow) {
    if (dartThrow.value == 0) return '0';
    int base = dartThrow.value ~/ dartThrow.multiplier;
    String prefix = '';
    switch (dartThrow.multiplier) {
      case 2:
        prefix = 'D';
        break;
      case 3:
        prefix = 'T';
        break;
    }
    return '$prefix$base';
  }

  bool _isCheckoutValid(List<DartThrow> throws) {
    if (_checkoutType != 'Double Out') return true;
    if (throws.isEmpty) return false;
    return throws.last.multiplier == 2;
  }

  void _submitScore() {
    List<DartThrow> currentThrows =
        selectedThrows.whereType<DartThrow>().toList();
    int score = currentThrows.fold(
      0,
      (sum, dartThrow) => sum + dartThrow.value,
    );
    int newPoints = remainingPoints[currentPlayerIndex] - score;

    bool isBust = false;
    bool isWinning = false;

    if (newPoints < 0) {
      isBust = true;
    } else if (newPoints == 0) {
      isWinning = _isCheckoutValid(currentThrows);
      if (!isWinning) isBust = true;
    }

    setState(() {
      if (isBust) {
        selectedThrows = [null, null, null];
        multiplier = 1;
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      } else if (isWinning) {
        _showWinnerDialog(players[currentPlayerIndex].name ?? 'Player');
      } else {
        remainingPoints[currentPlayerIndex] = newPoints;
        selectedThrows = [null, null, null];
        multiplier = 1;
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToCurrentPlayer(),
    );
  }

  void _showWinnerDialog(String winner) {
    List<GameResultDto> gameResults = [];

    gameResults.add(
      GameResultDto(
        playerId: players[currentPlayerIndex].id ?? -1,
        isWinner: true,
      ),
    );

    for (int i = 0; i < players.length; i++) {
      if (i != currentPlayerIndex) {
        gameResults.add(
          GameResultDto(playerId: players[i].id ?? -1, isWinner: false),
        );
      }
    }

    final apiService = ApiService();
    apiService.postGameResult(gameResults);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Game Over'),
            content: Text('$winner has won the game!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _selectNumber(int number) {
    if (selectedThrows.every((t) => t != null)) return;

    int effectiveMultiplier = multiplier;
    if (number == 0) {
      effectiveMultiplier = 1;
    } else if (number == 25) {
      effectiveMultiplier = effectiveMultiplier.clamp(1, 2);
    }
    int value = number * effectiveMultiplier;

    for (int i = 0; i < selectedThrows.length; i++) {
      if (selectedThrows[i] == null) {
        setState(() {
          selectedThrows[i] = DartThrow(
            value: value,
            multiplier: effectiveMultiplier,
          );
          multiplier = 1;
        });
        break;
      }
    }
  }

  void _setMultiplier(int value) {
    if (selectedThrows.every((t) => t != null)) return;
    setState(() => multiplier = (multiplier == value) ? 1 : value);
  }

  void _undoLastThrow() {
    for (int i = selectedThrows.length - 1; i >= 0; i--) {
      if (selectedThrows[i] != null) {
        setState(() => selectedThrows[i] = null);
        break;
      }
    }
  }

  Color _getTextColor(int index, int currentSum) {
    if (index != currentPlayerIndex) return Colors.black;
    int potential = remainingPoints[index] - currentSum;
    if (potential < 0) return Colors.red;
    if (potential == 0) {
      return _isCheckoutValid(selectedThrows.whereType<DartThrow>().toList())
          ? Colors.green
          : Colors.red;
    }
    return Colors.black;
  }

  Widget _buildNumberButton(int number, int potentialNewPoints) {
    bool throwsComplete = selectedThrows.every((t) => t != null);
    bool disabledForTriple25 = (number == 25 && multiplier == 3);
    bool buttonEnabled =
        !throwsComplete && !disabledForTriple25 && potentialNewPoints > 0;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: buttonEnabled ? Colors.white : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: buttonEnabled ? () => _selectNumber(number) : null,
          child: Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: buttonEnabled ? Colors.grey : Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: buttonEnabled ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color color,
    VoidCallback? onPressed, {
    bool isActive = false,
    required int potentialNewPoints,
  }) {
    bool isEnabled = onPressed != null;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnabled
                    ? (isActive ? color : Colors.transparent)
                    : Colors.grey.shade300,
            foregroundColor:
                isEnabled
                    ? (isActive ? Colors.white : color)
                    : Colors.grey.shade600,
            side:
                isEnabled && !isActive
                    ? BorderSide(color: color, width: 1)
                    : null,
            elevation: isActive ? 4 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color:
                  isEnabled
                      ? (isActive ? Colors.white : color)
                      : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    List<DartThrow> currentThrows =
        selectedThrows.whereType<DartThrow>().toList();
    int currentSum = currentThrows.fold(0, (sum, t) => sum + t.value);
    int currentPlayerRemaining = remainingPoints[currentPlayerIndex];
    int potentialNewPoints = currentPlayerRemaining - currentSum;
    bool isCheckoutValid =
        potentialNewPoints == 0 ? _isCheckoutValid(currentThrows) : false;

    bool canUndo = selectedThrows.any((t) => t != null);
    bool canSubmit =
        currentThrows.isNotEmpty &&
        (currentThrows.length == 3 || potentialNewPoints <= 0);

    return Scaffold(
      appBar: AppBar(title: Text('$_initialPoints, $_checkoutType')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Card(
                    key: playerKeys[index],
                    color:
                        index == currentPlayerIndex
                            ? Colors.grey.shade500
                            : Colors.grey.shade200,
                    child: ListTile(
                      title: Text(players[index].name ?? 'Player ${index + 1}'),
                      trailing: Text(
                        index == currentPlayerIndex
                            ? '${remainingPoints[index] - currentSum}'
                            : '${remainingPoints[index]}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(index, currentSum),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
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
                                e != null ? _getThrowDisplay(e) : '',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            SizedBox(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 7,
                childAspectRatio: 0.8,
                padding: const EdgeInsets.all(2),
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children:
                    [...List.generate(20, (index) => index + 1), 25]
                        .map(
                          (number) =>
                              _buildNumberButton(number, potentialNewPoints),
                        )
                        .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
              child: Row(
                children: [
                  _buildActionButton(
                    'MISS',
                    Colors.grey,
                    (potentialNewPoints > 0 &&
                            !selectedThrows.every((t) => t != null))
                        ? () => _selectNumber(0)
                        : null,
                    isActive: false,
                    potentialNewPoints: potentialNewPoints,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    'DOUBLE',
                    Colors.orange,
                    (potentialNewPoints > 0 &&
                            !selectedThrows.every((t) => t != null))
                        ? () => _setMultiplier(2)
                        : null,
                    isActive: multiplier == 2,
                    potentialNewPoints: potentialNewPoints,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    'TRIPLE',
                    Colors.deepOrange,
                    (potentialNewPoints > 0 &&
                            !selectedThrows.every((t) => t != null))
                        ? () => _setMultiplier(3)
                        : null,
                    isActive: multiplier == 3,
                    potentialNewPoints: potentialNewPoints,
                  ),
                  const SizedBox(width: 4),
                  _buildActionButton(
                    'UNDO',
                    Colors.blue,
                    canUndo ? _undoLastThrow : null,
                    isActive: false,
                    potentialNewPoints: potentialNewPoints,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSubmit ? _submitScore : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canSubmit
                            ? (potentialNewPoints == 0 && isCheckoutValid
                                ? Colors.green
                                : Colors.orange)
                            : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'SUBMIT SCORE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: canSubmit ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
