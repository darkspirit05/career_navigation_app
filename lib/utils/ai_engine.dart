import '../models/question_model.dart';

// Convert internal tag keys to user-friendly traits
String getTraitName(String tag) {
  const Map<String, String> tagToTrait = {
    'tech': 'Analytical',
    'creative': 'Creative',
    'practical': 'Practical',
    'social': 'Social',
    'literary': 'Linguistic',
  };

  return tagToTrait[tag] ?? tag;
}

Map<String, int> scoreTags(Map<int, String> answers, List<Question> questions) {
  Map<String, int> tagScores = {};

  for (int i = 0; i < questions.length; i++) {
    final selected = answers[i];
    final index = questions[i].options.indexOf(selected!);
    final tag = questions[i].tags[index];

    tagScores[tag] = (tagScores[tag] ?? 0) + 1;
  }

  return tagScores;
}

List<String> recommendCareers(Map<String, int> tagScores) {
  const Map<String, List<String>> tagToCareers = {
    'tech': ['Software Developer', 'Data Scientist'],
    'creative': ['UI/UX Designer', 'Animator'],
    'practical': ['Mechanical Engineer', 'Electrician'],
    'social': ['Teacher', 'Psychologist'],
    'literary': ['Writer', 'Editor']
  };

  final sortedTags = tagScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  List<String> result = [];
  for (var entry in sortedTags.take(2)) {
    result.addAll(tagToCareers[entry.key]!);
  }
  return result;
}

// Add this for showing trait names
List<String> topTraits(Map<String, int> tagScores, int count) {
  final sortedTags = tagScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sortedTags.take(count).map((e) => getTraitName(e.key)).toList();
}
