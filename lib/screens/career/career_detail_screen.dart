import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CareerDetailScreen extends StatelessWidget {
  final String career;

  const CareerDetailScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    final details = _careerDetails[career];

    return Scaffold(
      appBar: AppBar(
        title: Text(career),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: details == null
          ? const Center(child: Text("Details not available"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📝 Description", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(details['description'] ?? '', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),
            Text("🛠 Skills Required", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...List<String>.from(details['skills'] ?? []).map(
                  (skill) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("• $skill"),
              ),
            ),

            const SizedBox(height: 16),
            Text("📚 Recommended Courses", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...List<String>.from(details['courses'] ?? []).map(
                  (course) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("• $course"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔍 Mock data (you can replace with Supabase or Isar later)
const Map<String, Map<String, dynamic>> _careerDetails = {
  'Software Developer': {
    'description': 'Designs and builds software applications.',
    'skills': ['Programming', 'Problem-solving', 'Algorithms'],
    'courses': ['CS50 by Harvard', 'Flutter Bootcamp', 'LeetCode DSA'],
  },
  'UI/UX Designer': {
    'description': 'Creates user-friendly designs and interfaces.',
    'skills': ['Design Thinking', 'Figma', 'User Research'],
    'courses': ['Google UX Design', 'Figma Masterclass'],
  },
  // Add more careers similarly...
};
