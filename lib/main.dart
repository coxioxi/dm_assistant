import 'package:dm_assistant/database/game_state.dart';
import 'package:dm_assistant/database/object_box.dart';
import 'package:dm_assistant/view/game_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

late Objectbox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await Objectbox.create();

  runApp(ChangeNotifierProvider(create: (_) => GameState(), child: TestApp()));
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: GameListScreen(),
    );
  }
}
