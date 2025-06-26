import 'package:flutter/material.dart';

class CareerDetailScreen extends StatelessWidget {
  final String career;

  const CareerDetailScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    final details = _careerDetails[career];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: details == null
          ? const Center(child: Text("Details not available"))
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(career),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, "📝 Description"),
                      _sectionContent(details['description'] ?? ''),

                      const SizedBox(height: 24),
                      _sectionTitle(context, "🛠 Skills Required"),
                      ..._buildBulletList(details['skills']),

                      const SizedBox(height: 24),
                      _sectionTitle(context, "📚 Recommended Courses"),
                      ..._buildBulletList(details['courses']),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  List<Widget> _buildBulletList(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Text("• No data available.", style: TextStyle(fontSize: 15)),
        ),
      ];
    }

    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("• ", style: TextStyle(fontSize: 15)),
            Expanded(
              child: Text(item, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      );
    }).toList();
  }
}

/// 🔍 Career data — mock version (replace with Supabase/Isar if needed)
const Map<String, Map<String, dynamic>> _careerDetails = {
  'Software Developer': {
    'description': 'Designs and develops software systems using programming languages.',
    'skills': ['Programming', 'Problem-solving', 'Algorithms', 'Version Control'],
    'courses': ['CS50 by Harvard', 'Flutter Bootcamp', 'LeetCode DSA'],
  },
  'Data Scientist': {
    'description': 'Analyzes and interprets complex data to help organizations make decisions.',
    'skills': ['Python', 'Statistics', 'Machine Learning', 'Data Visualization'],
    'courses': ['IBM Data Science', 'Machine Learning by Andrew Ng', 'Kaggle Courses'],
  },
  'AI Engineer': {
    'description': 'Builds AI systems that mimic human behavior using ML algorithms.',
    'skills': ['Deep Learning', 'NLP', 'TensorFlow', 'Python'],
    'courses': ['DeepLearning.ai Specialization', 'FastAI', 'ML Zoomcamp'],
  },
  'UI/UX Designer': {
    'description': 'Designs intuitive and user-centered digital interfaces.',
    'skills': ['Figma', 'User Research', 'Wireframing', 'Design Thinking'],
    'courses': ['Google UX Design', 'Figma Masterclass', 'DesignLab UX Bootcamp'],
  },
  'Animator': {
    'description': 'Creates moving visuals for films, games, and apps.',
    'skills': ['2D/3D Animation', 'Adobe After Effects', 'Creativity'],
    'courses': ['Animation Mentor', 'Udemy 2D Animation', 'Blender Guru'],
  },
  'Graphic Designer': {
    'description': 'Designs visual content for communication and branding.',
    'skills': ['Photoshop', 'Illustrator', 'Typography', 'Color Theory'],
    'courses': ['Coursera Graphic Design', 'Adobe Masterclass', 'Canva Design School'],
  },
  'Mechanical Engineer': {
    'description': 'Designs and builds mechanical systems and devices.',
    'skills': ['CAD', 'Thermodynamics', 'Mathematics', 'Manufacturing'],
    'courses': ['MIT Mechanical Design', 'Coursera Mechatronics', 'SolidWorks Training'],
  },
  'Electrician': {
    'description': 'Installs and repairs electrical systems in buildings.',
    'skills': ['Circuit Analysis', 'Troubleshooting', 'Safety Codes'],
    'courses': ['Electrician Certification', 'SkillShare Basics of Electricity'],
  },
  'Civil Engineer': {
    'description': 'Plans and supervises infrastructure like roads and buildings.',
    'skills': ['Structural Design', 'AutoCAD', 'Project Management'],
    'courses': ['NPTEL Civil Engineering', 'Coursera Structural Engineering'],
  },
  'Teacher': {
    'description': 'Educates students by delivering subject knowledge interactively.',
    'skills': ['Communication', 'Patience', 'Adaptability', 'Subject Mastery'],
    'courses': ['Teach for India Fellowship', 'Coursera Teaching Skills'],
  },
  'Psychologist': {
    'description': 'Studies mental processes and helps people cope with issues.',
    'skills': ['Empathy', 'Analysis', 'Counseling', 'Research'],
    'courses': ['Introduction to Psychology (Yale)', 'Therapy Courses - Udemy'],
  },
  'HR Specialist': {
    'description': 'Manages recruitment, employee relations, and company policies.',
    'skills': ['Interpersonal Skills', 'Recruitment', 'Conflict Resolution'],
    'courses': ['LinkedIn HR Certification', 'HR Management by Coursera'],
  },
  'Writer': {
    'description': 'Creates content for books, blogs, ads, and more.',
    'skills': ['Grammar', 'Creativity', 'Editing', 'SEO'],
    'courses': ['Creative Writing - Wesleyan', 'SEO Content Writing - Udemy'],
  },
  'Editor': {
    'description': 'Refines and polishes written content for clarity and correctness.',
    'skills': ['Attention to Detail', 'Grammar', 'Proofreading'],
    'courses': ['Copyediting - UC San Diego', 'Grammarly Advanced Training'],
  },
  'Content Strategist': {
    'description': 'Plans, writes, and manages content to meet marketing goals.',
    'skills': ['SEO', 'Analytics', 'Content Planning'],
    'courses': ['HubSpot Content Strategy', 'Google Digital Garage'],
  },
};

