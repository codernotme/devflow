import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_client.dart';
import '../models/priority.dart';

class Project {
  final String id;
  final String name;
  final String? description;
  final Priority priority;
  final String status;

  Project({
    required this.id,
    required this.name,
    this.description,
    required this.priority,
    required this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      priority: Priority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => Priority.medium,
      ),
      status: json['status'],
    );
  }
}

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/projects/');
  final List<dynamic> data = response.data;
  return data.map((json) => Project.fromJson(json)).toList();
});
