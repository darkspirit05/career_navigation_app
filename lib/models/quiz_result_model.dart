import 'package:isar/isar.dart';

part 'quiz_result_model.g.dart';

@collection
class QuizResult {
  Id id = Isar.autoIncrement;

  late List<String> recommendedCareers;

  // Use a flattened string format for storage, e.g., "0:Creative", "1:Tech"
  late List<String> storedAnswers;

  late List<String> tags;

  late DateTime timestamp;
}
