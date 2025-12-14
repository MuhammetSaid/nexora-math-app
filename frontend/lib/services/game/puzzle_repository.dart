import '../../models/game/puzzle.dart';

/// Abstraction layer for loading puzzles.
abstract class PuzzleRepository {
  /// TODO: FastAPI'den çekilecek.
  Future<Puzzle> fetchLevel(int level);
}

/// Temporary mock repository that serves static placeholder content.
class MockPuzzleRepository implements PuzzleRepository {
  const MockPuzzleRepository();

  @override
  Future<Puzzle> fetchLevel(int level) async {
    return Puzzle(
      level: level,
      lines: const <String>[
        '5, 3 = 28',
        '7, 6 = 55',
        '4, 5 = 21',
        '3, 8 = ?',
      ],
    );
  }
}
