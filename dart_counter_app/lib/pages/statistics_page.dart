import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player_stats_dto.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  final ApiService apiService = ApiService();
  late Future<List<PlayerStatsDto>> futurePlayerStats;

  @override
  void initState() {
    super.initState();
    futurePlayerStats = apiService.fetchPlayerStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<PlayerStatsDto>>(
                future: futurePlayerStats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  final playerStats = snapshot.data!;
                  return LayoutBuilder(
                    // Use LayoutBuilder
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          // Use ConstrainedBox
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ), // Force minWidth
                          child: DataTable(
                            columnSpacing: 20,
                            headingRowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.grey.shade300,
                            ),
                            columns: const [
                              DataColumn(
                                label: Expanded(
                                  child: Center(child: Text('Player')),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Center(child: Text('Wins')),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Center(child: Text('Games')),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Center(child: Text('Win-Ratio')),
                                ),
                              ),
                            ],
                            rows:
                                playerStats.map((player) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Center(child: Text(player.name)),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(player.wins.toString()),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            player.totalGames.toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            '${player.winRatio.toStringAsFixed(0)}%',
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
