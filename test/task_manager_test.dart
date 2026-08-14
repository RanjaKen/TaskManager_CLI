import 'package:taskmanagercli/data/data.dart';
import 'package:taskmanagercli/exception/taskDuplicateException.dart';
import 'package:taskmanagercli/exception/taskNotFoundException.dart';
import 'package:taskmanagercli/models/normalTask.dart';
import 'package:taskmanagercli/models/priority.dart';
import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/models/urgentTask.dart';
import 'package:taskmanagercli/repo/taskRepository.dart';
import 'package:taskmanagercli/services/taskService.dart';
import 'package:test/test.dart';

class InMemoryTaskData implements Data<Task> {
  List<Task> _tasks = [];
  @override
  Future<List<Task>> load() async => List.of(_tasks);
  @override
  Future<void> save(List<Task> items) async => _tasks = List.of(items);
}

NormalTask normalTask({int id = 1, Priority priority = Priority.low}) =>
    NormalTask(id: id, title: 'Task $id', priority: priority);

void main() {
  late Taskrepository repository;
  late Taskservice service;
  setUp(() {
    repository = Taskrepository(InMemoryTaskData());
    service = Taskservice(repository);
  });

  test('adds and retrieves a task', () async {
    await repository.add(normalTask());
    expect((await repository.getAll()).single.title, 'Task 1');
  });
  test('rejects duplicate IDs', () async {
    await repository.add(normalTask());
    expect(
      () => repository.add(normalTask()),
      throwsA(isA<DuplicateTaskException>()),
    );
  });
  test('deletes a task', () async {
    await repository.add(normalTask());
    await repository.delete(1);
    expect(await repository.getAll(), isEmpty);
  });
  test('throws custom exception for an unknown task', () {
    expect(() => repository.delete(99), throwsA(isA<TaskNotFoundException>()));
  });
  test('marks a task as done', () async {
    await service.addTask(normalTask());
    await service.completeTask(1);
    expect((await repository.getAll()).single.isDone, isTrue);
  });
  test('sorts tasks by descending priority', () async {
    await service.addTask(normalTask(id: 1));
    await service.addTask(
      UrgentTask(id: 2, title: 'Urgent', priority: Priority.high),
    );
    await service.addTask(normalTask(id: 3, priority: Priority.medium));
    expect((await service.getAllTasks()).map((task) => task.id), [2, 3, 1]);
  });
}
