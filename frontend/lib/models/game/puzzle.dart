/// Simple puzzle model representing a level-based math riddle.
class Puzzle {
  const Puzzle({
    required this.level,
    required this.lines,
  });

  final int level;
  final List<String> lines;
}
