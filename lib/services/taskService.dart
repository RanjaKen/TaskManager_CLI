import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/repo/taskRepository.dart';
import 'package:taskmanagercli/services/serviceTask.dart';
import 'package:taskmanagercli/exception/taskNotFoundException.dart';

class Taskservice implements taskService {
  final Taskrepository repository;
  Taskservice(this.repository);

  @override
  Future<void> addTask(Task task) async {
    if (task.title.trim().isEmpty) {
      throw ArgumentError.value(task.title, 'title', 'Title cannot be empty.');
    }

    await repository.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    // Implementation for updating a task
    await repository.update(task);
  }

  @override
  Future<void> deleteTask(int id) async {
    // Implementation for deleting a task
    await repository.delete(id);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final tasks = await repository.getAll();
    tasks.sort((a, b) {
      final priorityComparison = b.priority.level.compareTo(a.priority.level);
      if (priorityComparison != 0) return priorityComparison;
      return (a.deadline ?? DateTime(9999)).compareTo(
        b.deadline ?? DateTime(9999),
      );
    });
    return tasks;
  }

  @override
  Future<void> completeTask(int id) async {
    final tasks = await repository.getAll();

    final task = tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw TaskNotFoundException(id),
    );

    task.isDone = true;

    await repository.update(task);
  }
}
