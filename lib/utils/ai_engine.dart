import '../models/question_model.dart';

/// Converts internal tag keys to user-friendly trait names
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

/// Safely scores the user's answers against tags
Map<String, int> scoreTags(Map<int, String> answers, List<Question> questions) {
  final Map<String, int> tagScores = {};

  for (int i = 0; i < questions.length; i++) {
    // Skip if no answer provided for this question
    if (!answers.containsKey(i)) continue;

    final selected = answers[i];
    if (selected == null) continue;

    final options = questions[i].options;
    final tags = questions[i].tags;

    final index = options.indexOf(selected);
    if (index == -1 || index >= tags.length) continue;

    final tag = tags[index];
    tagScores[tag] = (tagScores[tag] ?? 0) + 1;
  }

  return tagScores;
}

/// Recommends careers based on top scoring tags
List<String> recommendCareers(Map<String, int> tagScores) {
  const Map<String, List<String>> tagToCareers = {
    'tech': ['Software Developer', 'Data Scientist'],
    'creative': ['UI/UX Designer', 'Animator'],
    'practical': ['Mechanical Engineer', 'Electrician'],
    'social': ['Teacher', 'Psychologist'],
    'literary': ['Writer', 'Editor'],
  };

  final sortedTags = tagScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final List<String> result = [];
  for (var entry in sortedTags.take(2)) {
    result.addAll(tagToCareers[entry.key] ?? []);
  }

  return result;
}

/// Converts top tag scores into trait names
List<String> topTraits(Map<String, int> tagScores, int count) {
  final sortedTags = tagScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sortedTags.take(count).map((e) => getTraitName(e.key)).toList();
}
