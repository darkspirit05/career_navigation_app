import 'dart:ui';
import 'package:CareerVerse/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            title: const Text('Career Quiz'),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 2,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.06),
                  theme.colorScheme.secondary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: sampleQuestions.length,
              itemBuilder: (context, index) {
                final q = sampleQuestions[index];
                final questionId = index.toString();

                return Animate(
                  delay: Duration(milliseconds: 100 * index),
                  effects: const [FadeEffect(), SlideEffect(begin: Offset(0, 0.1))],
                  child: QuestionCard(
                    questionNumber: index + 1,
                    question: q.question,
                    options: q.options,
                    selectedOption: selectedAnswers[questionId],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[questionId] = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 12),
            child: FloatingActionButton.extended(
              onPressed: isSubmitting ? null : _submitAnswers,
              icon: const Icon(Icons.check_circle),
              label: Text(
                isSubmitting ? "Submitting..." : "Submit",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor:
              isSubmitting ? Colors.grey : theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 6,
            ),
          ),
        ),
        if (isSubmitting)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
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
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: color.surface.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.outlineVariant.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Q$questionNumber. $question",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
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
        ),
      ),
    );
  }
}
