class Question {
  final String question;
  final List<String> options;
  final List<String> tags;

  Question({
    required this.question,
    required this.options,
    required this.tags,
  });

  /// Factory constructor to create a Question from a Map (useful for JSON or DB)
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      options: List<String>.from(map['options']),
      tags: List<String>.from(map['tags']),
    );
  }

  /// Convert the Question to a Map (e.g., for saving to DB)
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'tags': tags,
    };
  }
}
