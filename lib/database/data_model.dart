import 'package:objectbox/objectbox.dart';

/// Represents a single Dungeons & Dragons (or similar) game session.
///
/// This entity is stored locally using ObjectBox.
@Entity()
class Game {
  /// ObjectBox-generated unique ID for the Game.
  @Id()
  int id;

  /// Name or title of the game session.
  String name;

  /// The date and time when the game was created.
  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Backlink('game')
  final creatures = ToMany<Creature>();

  @Backlink('game')
  final gameLogs = ToMany<GameLogs>();

  /// Creates a new [Game] instance.
  Game({required this.name, required this.createdAt, this.id = 0});
}

/// Represents a creature (Player Character/Non Player Character) in a game session.
@Entity()
class Creature {
  @Id()
  int id; // Unique identifier for the monster

  String name; // Monster's name

  String? damage; // Description of the monster's damage (e.g., "1d6 + 3")

  int hp; // Hit points

  int ac; // Armor Class

  int initModifier; // Initiative modifier

  int? initiativeNum; // Initiative value after rolling (nullable until set)

  bool npc;

  // Relationship to the Game entity (each monster belongs to one game)
  final game = ToOne<Game>();

  Creature({
    required this.name,
    required this.hp,
    required this.ac,
    required this.initModifier,
    required this.npc,
    this.id = 0,
  });
}

/// Stores log entries related to gameplay, like dice rolls or combat events.
@Entity()
class GameLogs {
  @Id()
  int id; // Unique identifier for the log entry

  String message; // The log message (e.g., "Player rolled 17")

  String type; // The type of log ("dice" or "combat")

  @Property(type: PropertyType.date)
  DateTime timestamp; // When the log entry was created

  // Relationship to the Game entity (each log belongs to one game)
  final game = ToOne<Game>();

  GameLogs({
    required this.message,
    required this.timestamp,
    required this.type,
    this.id = 0,
  });
}
