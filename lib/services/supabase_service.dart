import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<void> saveQuizResult({
    required Map<String, String> answers,
    required List<String> recommendedCareers,
    required List<String> tags,
  }) async {
    await supabase.from('quiz_results').insert({
      'answers': answers,
      'recommended_careers': recommendedCareers,
      'tags': tags,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final response = await supabase.from('quiz_results').select().order('created_at', ascending: false);
    return response;
  }
}
