import 'package:taskmanagercli/models/normalTask.dart';
import 'package:taskmanagercli/models/priority.dart';
import 'package:taskmanagercli/models/urgentTask.dart';

abstract class Task {
  final String id;
  final String title;
  final DateTime? deadline;
  final Priority priority;
  final DateTime createdAt;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.deadline,
    required this.priority,
    DateTime? createdAt,
  }): createdAt = createdAt ?? DateTime.now();


void showDetails();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "priority": priority.name,
      "deadline": deadline?.toIso8601String(),
      "isDone": isDone,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    final priority = Priority.values.byName(json["priority"]);

    if (priority == Priority.high) {
      return UrgentTask(
        id: json["id"],
        title: json["title"],
        priority: priority,
        deadline: json["deadline"] != null
            ? DateTime.parse(json["deadline"])
            : null,
        isDone: json["isDone"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
    }

    return NormalTask(
      id: json["id"],
      title: json["title"],
      priority: priority,
      deadline: json["deadline"] != null
          ? DateTime.parse(json["deadline"])
          : null,
      isDone: json["isDone"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}


