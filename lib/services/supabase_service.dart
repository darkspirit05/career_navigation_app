import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  /// Save quiz result with necessary formatting and error handling
  Future<void> saveQuizResult({
    required Map<int, String> answers,
    required List<String> recommendedCareers,
    required List<String> tags,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    final storedAnswers = answers.entries.map((e) => '${e.key}:${e.value}').toList();

    try {
      await supabase.from('quiz_results').insert({
        'user_id': userId,
        'answers': storedAnswers,
        'recommended_careers': recommendedCareers,
        'tags': tags,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("❌ Supabase insert error: $e");
      rethrow;
    }
  }

  /// Fetch history for the current user
  Future<List<Map<String, dynamic>>> getHistory() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await supabase
          .from('quiz_results')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Supabase fetch error: $e");
      return [];
    }
  }
}
