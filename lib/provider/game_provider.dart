import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe/models/player.dart';

class GameProvider extends ChangeNotifier {
  static const _countMatrix = 3;

  List<List<String>> _matrix = [];

  List<List<String>> get matrix => _matrix;

  String lastMove = Player.none;

  late bool _isGameOver;

  bool get isGameOver => _isGameOver;

  GameProvider() {
    init();
  }

  init() {
    _matrix = List.generate(
      _countMatrix,
      (index) => List.generate(
        _countMatrix,
        (index) => Player.none,
      ),
    );
    _isGameOver = false;
  }

  void plateOnTapped(String value, int row, int column) {
    if (value == Player.none) {
      final newValue = lastMove == Player.X ? Player.O : Player.X;
      lastMove = newValue;

      _matrix[row][column] = newValue;

      if (isWinner(row, column)) {
        _isGameOver = true;
      }

      notifyListeners();
    }
  }

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, antiDiag = 0;

    final player = _matrix[x][y];

    const n = _countMatrix;

    for (var i = 0; i < n; i++) {
      if (_matrix[i][y] == player) col++;

      if (_matrix[x][i] == player) row++;

      if (_matrix[i][i] == player) diag++;

      if (_matrix[i][_countMatrix - i - 1] == player) antiDiag++;
    }

    return col == n || row == n || diag == n || antiDiag == n;
  }
}

final gameProvider = ChangeNotifierProvider((ref) => GameProvider());
