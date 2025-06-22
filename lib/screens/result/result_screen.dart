import 'package:ai_career_navigator/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/questions.dart';
import '../../utils/ai_engine.dart';
import '../../core/constants.dart';

class ResultScreen extends StatefulWidget {
  final Map<int, String> answers;

  const ResultScreen({super.key, required this.answers});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final supabase = Supabase.instance.client;

  List<String> careers = [];
  late DateTime timestamp;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    processResult();
  }

  Future<void> processResult() async {
    final tagScores = scoreTags(widget.answers, sampleQuestions);
    final topCareers = recommendCareers(tagScores);
    timestamp = DateTime.now();

    final storedAnswers = widget.answers.entries
        .map((e) => '${e.key}:${e.value}')
        .toList();

    final userId = supabase.auth.currentUser?.id;

    // Check if result was loaded from history
    final fromHistory = (ModalRoute.of(context)?.settings.arguments as Map?)?['fromHistory'] == true;

    if (fromHistory) {
      setState(() {
        careers = topCareers;
        isLoading = false;
      });
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
    final text = 'My recommended career path: ${careers.join(', ')}';
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
            child: ListView.builder(
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
                    leading: const Icon(Icons.star_outline, color: AppColors.primary),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
