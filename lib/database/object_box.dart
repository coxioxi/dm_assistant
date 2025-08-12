import 'data_model.dart';
import 'objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class Objectbox {
  /// The main ObjectBox [Store] used to access and manage the database.
  late final Store store;

  /// A [Box] for interacting with [Game] entities in the database.
  late final Box<Game> gameBox;

  /// A [Box] for interacting with [GameLogs] entities in the database.
  late final Box<GameLogs> gameLogsBox;

  /// Private constructor that initializes the store and entity boxes.
  Objectbox._create(this.store) {
    gameBox = Box<Game>(store);
    gameLogsBox = Box<GameLogs>(store);
  }

  /// Asynchronously creates and returns an [Objectbox] instance with the store initialized.
  static Future<Objectbox> create() async {
    final dir = await getApplicationDocumentsDirectory(); // <- Writable path
    final store = await openStore(directory: dir.path); // <- Pass it here
    return Objectbox._create(store);
  }

  /// Adds a new [Game].
  ///
  /// Returns the ID of the inserted game.
  int addGame(String gameName, DateTime date) {
    Game newGame = Game(name: gameName, createdAt: date);
    return gameBox.put(newGame);
  }

  void removeGame(Game game) {
    gameBox.remove(game.id);
  }

  /// Adds a new [GameLogs] entry to the specified [Game], with the given message and type.
  ///
  /// The [type] must be either `"dice"` or `"combat"`.
  /// Returns the ID of the inserted log entry.
  int addLog(String message, String type, Game game) {
    GameLogs newLog = GameLogs(
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );
    newLog.game.target = game;
    return gameLogsBox.put(newLog);
  }

  /// Retrieves a live stream of all [Game]s associated with a given [DM].
  ///
  /// This stream updates in real-time whenever the underlying data changes.
  Stream<List<Game>> getGames() {
    final query = gameBox.query();
    return query.watch(triggerImmediately: true).map((q) => q.find());
  }

  /// Retrieves a live stream of [GameLogs] of the specified [type] (`"dice"` or `"combat"`)
  /// for the given [Game], sorted by timestamp in descending order (latest first).
  ///
  /// Throws an [Exception] if the [type] is invalid.
  Stream<List<GameLogs>> getLogs(String type, Game game) {
    if (!(type.contains('dice') || type.contains('combat'))) {
      throw Exception("$type is not valid!");
    }

    final query = gameLogsBox
        .query(GameLogs_.game.equals(game.id).and(GameLogs_.type.equals(type)))
        .order(GameLogs_.timestamp, flags: Order.descending);

    return query.watch(triggerImmediately: true).map((query) => query.find());
  }
}
