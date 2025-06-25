import 'package:ai_career_navigator/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../../data/questions.dart';
import '../../widgets/custom_radio_tile.dart';

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
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<int, String> intAnswers = selectedAnswers.map(
          (key, value) => MapEntry(int.parse(key), value),
    );

    if (mounted) {
      Navigator.pushNamed(
        context,
        '/results',
        arguments: {
          'fromHistory': false,
          'answers': intAnswers,
        },
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
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text('Career Quiz'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 2,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: sampleQuestions.length,
            itemBuilder: (context, index) {
              final q = sampleQuestions[index];
              final questionId = index.toString();

              return QuestionCard(
                questionNumber: index + 1,
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12, right: 12),
            child: FloatingActionButton.extended(
              onPressed: isSubmitting ? null : _submitAnswers,
              label: const Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              backgroundColor: isSubmitting
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
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
  final int questionNumber;
  final String question;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String> onChanged;

  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q$questionNumber. $question",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
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
