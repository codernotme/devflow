import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_client.dart';
import '../models/task_status.dart';
import '../models/priority.dart';

class TaskItem {
  final String id;
  final String? projectId;
  final String title;
  final TaskStatus status;
  final Priority priority;

  TaskItem({
    required this.id,
    this.projectId,
    required this.title,
    required this.status,
    required this.priority,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.todo,
      ),
      priority: Priority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => Priority.medium,
      ),
    );
  }
}

final tasksProvider = FutureProvider<List<TaskItem>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/tasks/');
  final List<dynamic> data = response.data;
  return data.map((json) => TaskItem.fromJson(json)).toList();
});
