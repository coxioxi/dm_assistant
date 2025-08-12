import 'package:flutter/material.dart';

/// A [ChangeNotifier] that manages and broadcasts changes to the current game ID.
///
/// This class is used to store and update the active game ID (`gameId`)
/// so that all screens and widgets depending on the selected game can fetch
/// data from the appropriate game instance in the local database or cloud.
///
/// Typically, this would be provided at a high level in the widget tree using
/// a [ChangeNotifierProvider] (such as from the `provider` package) so that
/// all descendant widgets can listen to changes.
///
/// Example usage:
///
/// ```dart
/// Provider.of<GameState>(context, listen: false).setGameId(game.id);
/// ```
///
/// Then in other widgets:
/// ```dart
/// final currentGameId = Provider.of<GameState>(context).gameId;
/// ```
class GameState extends ChangeNotifier {
  int? _gameId;

  /// Gets the current game ID.
  int? get gameId => _gameId;

  /// Updates the current game ID and notifies listeners.
  ///
  /// Use this when a user selects a different saved game so that
  /// other parts of the app can react and load the corresponding data.
  void setGameId(int id) {
    _gameId = id;
    notifyListeners();
  }
}
