import 'package:dm_assistant/database/game_state.dart';
import 'package:dm_assistant/main.dart';
import 'package:dm_assistant/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreen();
}

class _GameListScreen extends State<GameListScreen> {
  TextEditingController gameName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Games')),

      body: StreamBuilder(
        stream: objectbox.getGames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final games = snapshot.data!;

          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_outlined, size: 40),
                  Text('No Games Found', style: TextStyle(fontSize: 24)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    final gameId = game.id;
                    debugPrint('$gameId');
                    Provider.of<GameState>(
                      context,
                      listen: false,
                    ).setGameId(game.id);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: ListTile(
                      title: Text(game.name),
                      subtitle: Text(game.createdAt.toString()),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                'Are you sure you wanna delete this game?',
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Back'),
                                ),

                                TextButton(
                                  onPressed: () {
                                    objectbox.removeGame(game);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Create a Game'),

              content: TextField(
                controller: gameName,
                autofocus: true,

                decoration: const InputDecoration(hintText: 'Enter Game Name'),
              ),

              actions: [
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    objectbox.addGame(gameName.text, DateTime.now());
                    gameName.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }),
        tooltip: 'Create a New Game',
        child: const Icon(Icons.add),
      ),
    );
  }
}
