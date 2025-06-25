import 'package:ai_career_navigator/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/questions.dart';
import '../../utils/ai_engine.dart';
import '../career/career_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final Map<int, String>? answers;

  const ResultScreen({super.key, this.answers});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final supabase = Supabase.instance.client;

  List<String> allCareers = [];
  List<String> displayedCareers = [];
  List<String> topTraitsList = [];
  String selectedTrait = '';
  String explanation = '';
  DateTime? timestamp;
  late Map<int, String> finalAnswers;

  bool isLoading = true;
  bool _initialized = false;

  Map<int, String> castAnswers(dynamic input) {
    if (input is Map) {
      return Map<int, String>.fromEntries(
        input.entries.map((entry) {
          final key = int.tryParse(entry.key.toString());
          return key != null ? MapEntry(key, entry.value.toString()) : null;
        }).whereType<MapEntry<int, String>>(),
      );
    }
    return {};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map && args['fromHistory'] == true) {
      final rawAnswers = args['answers'];
      finalAnswers = castAnswers(rawAnswers);
      allCareers = List<String>.from(args['recommendedCareers'] ?? []);
      displayedCareers = [...allCareers];
      timestamp = args['timestamp'] ?? DateTime.now();
      final tagScores = scoreTags(finalAnswers, sampleQuestions);
      explanation = generateExplanationFromTraits(tagScores);
      topTraitsList = topTraits(tagScores, 2);
      setState(() => isLoading = false);
    } else if (args is Map && args['answers'] != null) {
      final rawAnswers = args['answers'];
      finalAnswers = castAnswers(rawAnswers);
      processResult();
    } else {
      finalAnswers = widget.answers ?? {};
      processResult();
    }
  }

  Future<void> processResult() async {
    if (finalAnswers.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    final tagScores = scoreTags(finalAnswers, sampleQuestions);
    final topCareers = recommendCareers(tagScores);

    allCareers = topCareers;
    displayedCareers = [...topCareers];
    topTraitsList = topTraits(tagScores, 2);
    explanation = generateExplanationFromTraits(tagScores);
    timestamp = DateTime.now();

    final storedAnswers = finalAnswers.entries.map((e) => '${e.key}:${e.value}').toList();
    final userId = supabase.auth.currentUser?.id;

    if (userId != null) {
      try {
        await supabase.from('quiz_results').insert({
          'answers': storedAnswers,
          'recommended_careers': topCareers,
          'tags': tagScores.keys.take(2).toList(),
          'timestamp': timestamp!.toIso8601String(),
          'user_id': userId,
        });
      } catch (e) {
        print("❌ Supabase error: $e");
      }
    }

    setState(() => isLoading = false);
  }

  void filterCareersByTrait(String trait) {
    if (selectedTrait == trait) {
      selectedTrait = '';
      displayedCareers = [...allCareers];
    } else {
      selectedTrait = trait;
      displayedCareers = allCareers.where((career) {
        return career.toLowerCase().contains(trait.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  void shareCareerPath() {
    final text = displayedCareers.isEmpty
        ? 'No career path was generated.'
        : 'My recommended career path: ${displayedCareers.join(', ')}';
    Share.share(text);
  }

  void retakeQuiz() {
    Navigator.pushNamedAndRemoveUntil(context, '/quiz', (route) => false);
  }

  void openCareerDetails(String careerName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerDetailScreen(career: careerName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Career Path"),
        backgroundColor: color.background,
        foregroundColor: color.inversePrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "Recommended Careers",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color.inversePrimary,
            ),
          ),
          if (timestamp != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Date: ${DateFormat.yMMMd().format(timestamp!)}",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Explanation", style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(explanation, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: topTraitsList.map((trait) {
              final isSelected = selectedTrait == trait;
              return FilterChip(
                label: Text(trait),
                selected: isSelected,
                onSelected: (_) => filterCareersByTrait(trait),
                selectedColor: color.primaryContainer,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? color.onPrimaryContainer
                      : color.inversePrimary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: displayedCareers.isEmpty
                ? const Center(
              child: Text(
                "No careers to display.\nTry retaking the quiz.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displayedCareers.length,
              itemBuilder: (context, index) {
                final career = displayedCareers[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: color.surface,
                  child: ListTile(
                    leading: Icon(Icons.star_outline,
                        color: color.secondary),
                    title: Text(
                      career,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => openCareerDetails(career),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: shareCareerPath,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
                ElevatedButton.icon(
                  onPressed: retakeQuiz,
                  icon: const Icon(Icons.replay),
                  label: const Text('Retake Quiz'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
