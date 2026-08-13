import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/repo/taskRepository.dart';
import 'package:taskmanagercli/services/serviceTask.dart';

class Taskservice implements taskService {
  final Taskrepository repository;
  Taskservice(this.repository);

  @override
  Future<void> addTask(Task task) async {
    // Implementation for adding a task
    if (task.title.isEmpty) {
      throw Exception("Title cannot be empty.");
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
    // Implementation for getting all tasks
    return await repository.getAll();
  }
  
  @override
  Future<void> completeTask(int id) async {
    // TODO: implement completeTask
    final tasks = await repository.getAll();

    final task = tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception("Task not found"),
    );

    task.isDone = true;

    await repository.update(task);
  }

  
  
}