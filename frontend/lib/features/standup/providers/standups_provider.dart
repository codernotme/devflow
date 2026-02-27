import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_client.dart';

class Standup {
  final String id;
  final String date; // YYYY-MM-DD
  final String yesterdayNotes;
  final String todayNotes;
  final String blockers;

  Standup({
    required this.id,
    required this.date,
    required this.yesterdayNotes,
    required this.todayNotes,
    required this.blockers,
  });

  factory Standup.fromJson(Map<String, dynamic> json) {
    return Standup(
      id: json['id'],
      date: json['date'],
      yesterdayNotes: json['yesterday_notes'],
      todayNotes: json['today_notes'],
      blockers: json['blockers'],
    );
  }
}

final standupsProvider = FutureProvider<List<Standup>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/standups/');
  final List<dynamic> data = response.data;
  return data.map((json) => Standup.fromJson(json)).toList();
});
