import 'package:ai_career_navigator/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../../data/questions.dart';
import '../../widgets/custom_radio_tile.dart';
import '../../core/constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Map<String, String> selectedAnswers = {};
  bool isSubmitting = false;

  Future<void> _submitAnswers() async {
    if (selectedAnswers.length < sampleQuestions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please answer all questions")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    // Simulate a small delay for UX smoothness
    await Future.delayed(const Duration(milliseconds: 500));

    // Convert keys back to int
    final Map<int, String> intAnswers = selectedAnswers.map(
          (key, value) => MapEntry(int.parse(key), value),
    );

    if (mounted) {
      Navigator.pushNamed(
        context,
        '/results',
        arguments: intAnswers,
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Q U I Z'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: ListView.builder(
            itemCount: sampleQuestions.length,
            itemBuilder: (context, index) {
              final q = sampleQuestions[index];
              final questionId = index.toString();

              return QuestionCard(
                question: q.question,
                options: q.options,
                selectedOption: selectedAnswers[questionId],
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[questionId] = value;
                  });
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: isSubmitting ? null : _submitAnswers,
            label: const Text("Submit", style: TextStyle(color: Colors.black),),
            icon: const Icon(Icons.send, color: Colors.black,),
            backgroundColor:
            isSubmitting ? Colors.grey : AppColors.primary,
          ),
        ),

        // Loading overlay
        if (isSubmitting)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String> onChanged;

  const QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            ...options.map(
                  (opt) => CustomRadioTile(
                title: opt,
                value: opt,
                groupValue: selectedOption,
                onChanged: (value) => onChanged(value!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
