import '../models/question_model.dart';

/// Map internal tag keys to user-friendly trait names
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

/// Score selected answers and aggregate trait scores
Map<String, int> scoreTags(Map<int, String> answers, List<Question> questions) {
  final Map<String, int> tagScores = {};

  for (int i = 0; i < questions.length; i++) {
    final selectedAnswer = answers[i];
    if (selectedAnswer == null) {
      print("⚠️ No answer selected for question $i");
      continue;
    }

    final index = questions[i].options.indexOf(selectedAnswer);
    if (index == -1 || index >= questions[i].tags.length) {
      print("⚠️ Invalid answer index for question $i: $selectedAnswer");
      continue;
    }

    final tag = questions[i].tags[index];
    tagScores[tag] = (tagScores[tag] ?? 0) + 1;
  }

  print("✅ Tag scores: $tagScores");
  return tagScores;
}

/// Map trait scores to careers using the top 2 traits
List<String> recommendCareers(Map<String, int> tagScores) {
  const Map<String, List<String>> tagToCareers = {
    'tech': ['Software Developer', 'Data Scientist', 'AI Engineer'],
    'creative': ['UI/UX Designer', 'Animator', 'Graphic Designer'],
    'practical': ['Mechanical Engineer', 'Electrician', 'Civil Engineer'],
    'social': ['Teacher', 'Psychologist', 'HR Specialist'],
    'literary': ['Writer', 'Editor', 'Content Strategist'],
  };

  final sortedTags = tagScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final topTags = sortedTags.take(2).map((e) => e.key).toList();
  print("🔍 Top tags: $topTags");

  final List<String> careers = [];
  for (var tag in topTags) {
    if (tagToCareers.containsKey(tag)) {
      careers.addAll(tagToCareers[tag]!);
    } else {
      print("⚠️ No careers found for tag '$tag'");
    }
  }

  print("🎯 Final recommended careers: $careers");
  return careers;
}

/// Convert top tags to user-friendly trait names
List<String> topTraits(Map<String, int> tagScores, int count) {
  final sorted = tagScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(count).map((e) => getTraitName(e.key)).toList();
}

/// Build a summary explanation based on top traits
String generateExplanationFromTraits(Map<String, int> tagScores) {
  if (tagScores.isEmpty) return "No explanation available.";

  final traits = topTraits(tagScores, 2);
  return "Based on your answers, you show strong traits in ${traits.join(' and ')}. "
      "The careers suggested are aligned with your strengths.";
}
