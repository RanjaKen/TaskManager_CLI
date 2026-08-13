import 'package:taskmanagercli/data/data.dart';
import 'package:taskmanagercli/exception/taskDuplicateException.dart';
import 'package:taskmanagercli/exception/taskNotFoundException.dart';
import 'package:taskmanagercli/models/normalTask.dart';
import 'package:taskmanagercli/models/priority.dart';
import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/models/urgentTask.dart';
import 'package:taskmanagercli/repo/taskRepository.dart';
import 'package:test/test.dart';

class testDataclimanager implements Data<Task> {
  List<Task> _tasks = [];

  @override
  Future<void> save(List<Task> items) async {
    _tasks = items;
  }

  @override
  Future<List<Task>> load() async {
    return _tasks;
  }

  
}

void main() {
    late Taskrepository repository;

    setUp(() {
      repository = Taskrepository(testDataclimanager());
    });

    test("should add a task", () async {
      final task = NormalTask(
        id: "1",
        title: "task one",
        priority: Priority.low,
        deadline: null,
        isDone: false,
      );

      await repository.add(task);

      final tasks = await repository.getAll();

      expect(tasks.length, 1);
      expect(tasks.first.title, "task one");
    });

    test("should not allow duplicate id", () async {
      final task = NormalTask(
        id: "1",
        title: "task one",
        priority: Priority.low,
        deadline: null,
        isDone: false,
      );

      await repository.add(task);

      await expectLater(
        repository.add(task),
        throwsA(isA<DuplicateTaskException>()),
      );
    });

    test("should remove existing task", () async {
      final task = NormalTask(
        id: "1",
        title: "Delete me",
        priority: Priority.low,
        deadline: null,
        isDone: false,
      );

      await repository.add(task);

      await repository.delete("1");

      final tasks = await repository.getAll();

      expect(tasks.isEmpty, true);
    });

    test("should throw when removing unknown task", () async {
      await expectLater(
        repository.delete("99"),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test("should update task", () async {
      final task = NormalTask(
        id: "1",
        title: "will update me",
        priority: Priority.low,
        deadline: null,
        isDone: false,
      );

      await repository.add(task);

      final updatedTask = UrgentTask(
        id: "1",
        title: "New title",
        priority: Priority.high,
        deadline: null,
        isDone: false,
      );

      await repository.update(updatedTask);

      final tasks = await repository.getAll();

      expect(tasks.first.title, "New title");
      expect(tasks.first.priority, Priority.high);
    });
    
  }