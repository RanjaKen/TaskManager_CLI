import 'package:taskmanagercli/data/data.dart';
import 'package:taskmanagercli/exception/taskDuplicateException.dart';
import 'package:taskmanagercli/exception/taskNotFoundException.dart';
import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/repo/repository.dart';

class Taskrepository implements Repository<Task> {
  final Data<Task> data;
  Taskrepository(this.data);

  @override
  Future<void> add(Task item) async {
    // Implementation for adding a task
    final tasks = await data.load();

    if (tasks.any((task) => task.id == item.id)) {
      throw DuplicateTaskException(item.id );
    }

    tasks.add(item);
    await data.save(tasks);
  }

  @override
  Future<void> update(Task item) async {
    // Implementation for updating a task
    final tasks = await data.load();

    final index = tasks.indexWhere((task) => task.id == item.id);

    if (index == -1) {
      throw TaskNotFoundException(item.id );
    }

    tasks[index] = item;

    await data.save(tasks);
  
  }

  @override
  Future<void> delete(int id) async {
    // Implementation for deleting a task
    final tasks = await data.load();

    if (!tasks.any((task) => task.id == id)) {
      throw TaskNotFoundException(id as int);
    }

    tasks.removeWhere((task) => task.id == id);

    await data.save(tasks);
  }

  @override
  Future<List<Task>> getAll() async {
    // Implementation for getting all tasks
    return await data.load();
  }

  
}