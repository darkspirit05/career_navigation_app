import 'package:ai_career_navigator/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final data = await supabase
          .from('quiz_results')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false);

      if (mounted) {
        setState(() {
          results = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to load history: $e')),
        );
      }
    }
  }

  Future<void> deleteResult(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Result'),
        content: const Text('Are you sure you want to delete this result?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await supabase.from('quiz_results').delete().match({'id': id});
      loadResults();
    }
  }

  Map<int, String> parseAnswers(dynamic raw) {
    final List<String> entries;
    if (raw == null) return {};
    if (raw is List) {
      entries = List<String>.from(raw.map((e) => e.toString()));
    } else if (raw is String) {
      entries = [raw];
    } else {
      return {};
    }

    final result = <int, String>{};
    for (var entry in entries) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final key = int.tryParse(parts[0]);
        if (key != null) {
          result[key] = parts[1];
        }
      }
    }
    return result;
  }

  List<String> safeListFrom(dynamic data) {
    if (data is List) {
      return List<String>.from(data.map((e) => e.toString()));
    } else if (data is String) {
      return [data];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : results.isEmpty
          ? const Center(child: Text("No history found"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];

          final topTags = safeListFrom(result['tags']);
          final recommendedCareers = safeListFrom(result['recommended_careers']);
          final answers = parseAnswers(result['answers']);
          final timestampRaw = result['timestamp'];

          final timestamp = timestampRaw is String
              ? DateTime.tryParse(timestampRaw) ?? DateTime.now()
              : DateTime.now();

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.card,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: topTags
                    .map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppColors.primary),
                ))
                    .toList(),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Date: ${DateFormat.yMMMd().format(timestamp)}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteResult(result['id']),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/results',
                  arguments: {
                    'answers': answers,
                    'recommendedCareers': recommendedCareers,
                    'timestamp': timestamp,
                    'fromHistory': true,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
