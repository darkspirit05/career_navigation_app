import 'package:ai_career_navigator/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/questions.dart';
import '../../utils/ai_engine.dart';
import '../../core/constants.dart';

class ResultScreen extends StatefulWidget {
  final Map<int, String>? answers;

  const ResultScreen({super.key, this.answers});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final supabase = Supabase.instance.client;

  List<String> careers = [];
  DateTime timestamp = DateTime.now(); // ✅ initialized to avoid LateError
  late Map<int, String> finalAnswers;

  bool isLoading = true;
  bool _initialized = false;

  Map<int, String> castAnswers(dynamic input) {
    if (input is Map) {
      return Map<int, String>.fromEntries(
        input.entries.map((entry) {
          final key = int.tryParse(entry.key.toString());
          if (key != null) {
            return MapEntry(key, entry.value.toString());
          } else {
            return const MapEntry(-1, '');
          }
        }).where((entry) => entry.key != -1),
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
      careers = List<String>.from(args['recommendedCareers'] ?? []);
      timestamp = args['timestamp'] ?? DateTime.now();
      setState(() => isLoading = false);
    } else {
      finalAnswers = widget.answers ?? {};
      processResult();
    }
  }

  Future<void> processResult() async {
    if (finalAnswers.isEmpty) {
      print("❌ Final answers are empty. Cannot calculate score.");
      setState(() {
        careers = [];
        isLoading = false;
      });
      return;
    }

    print("✅ Final Answers: $finalAnswers");

    final tagScores = scoreTags(finalAnswers, sampleQuestions);
    print("🎯 Tag Scores: $tagScores");

    final topCareers = recommendCareers(tagScores);
    print("🎓 Top Careers: $topCareers");

    timestamp = DateTime.now();

    final storedAnswers = finalAnswers.entries
        .map((e) => '${e.key}:${e.value}')
        .toList();

    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      setState(() {
        careers = topCareers;
        isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Not logged in. Result not saved.')),
        );
      }
      return;
    }

    try {
      await supabase.from('quiz_results').insert({
        'answers': storedAnswers,
        'recommended_careers': topCareers,
        'tags': tagScores.keys.take(2).toList(),
        'timestamp': timestamp.toIso8601String(),
        'user_id': userId,
      });

      setState(() {
        careers = topCareers;
        isLoading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🎉 Career result saved successfully!")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to save result: $e')),
        );
      }
    }
  }

  void shareCareerPath() {
    final text = careers.isEmpty
        ? 'No career path was generated.'
        : 'My recommended career path: ${careers.join(', ')}';
    Share.share(text);
  }

  void retakeQuiz() {
    Navigator.pushNamedAndRemoveUntil(context, '/quiz', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Career Path"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Recommended Careers",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Date: ${DateFormat.yMMMd().format(timestamp)}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: careers.isEmpty
                ? const Center(
              child: Text(
                "No recommended careers found.\nPlease complete the quiz properly.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: careers.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: AppColors.card,
                  child: ListTile(
                    leading: const Icon(Icons.star_outline,
                        color: AppColors.primary),
                    title: Text(
                      careers[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
