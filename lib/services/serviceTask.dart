import 'package:taskmanagercli/models/task.dart';

abstract class taskService {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
  Future<List<Task>> getAllTasks();
  Future<void> completeTask(int id);
}