import 'package:isar/isar.dart';

part 'quiz_result_model.g.dart';

@collection
class QuizResult {
  /// Unique ID auto-incremented by Isar
  Id id = Isar.autoIncrement;

  /// Recommended career titles generated from quiz
  late List<String> recommendedCareers;

  /// Stored answers in format like "0:Creative", "1:Tech"
  late List<String> storedAnswers;

  /// Top tags used for filtering (e.g., "tech", "creative")
  late List<String> tags;

  /// Timestamp of when the result was saved
  late DateTime timestamp;

  // Optionally: Add convenience getter to convert storedAnswers into map
  Map<int, String> get answersMap {
    final Map<int, String> result = {};
    for (var entry in storedAnswers) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final index = int.tryParse(parts[0]);
        if (index != null) {
          result[index] = parts[1];
        }
      }
    }
    return result;
  }
}
