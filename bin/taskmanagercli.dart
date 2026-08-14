import 'dart:io';

import 'package:taskmanagercli/data/taskData.dart';
import 'package:taskmanagercli/exception/taskDuplicateException.dart';
import 'package:taskmanagercli/exception/taskNotFoundException.dart';
import 'package:taskmanagercli/models/normalTask.dart';
import 'package:taskmanagercli/models/priority.dart';
import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/models/urgentTask.dart';
import 'package:taskmanagercli/repo/taskRepository.dart';
import 'package:taskmanagercli/services/taskService.dart';

Future<void> main(List<String> arguments) async {
  final service = Taskservice(Taskrepository(Taskdata('tasks.json')));

  while (true) {
    print('\n=== TASK MANAGER ===');
    print('1. Add a task');
    print('2. List tasks');
    print('3. Mark a task as done');
    print('4. Delete a task');
    print('5. Exit');
    stdout.write('Choose an option: ');

    switch (stdin.readLineSync()?.trim()) {
      case '1':
        await addTask(service);
      case '2':
        await listTasks(service);
      case '3':
        await completeTask(service);
      case '4':
        await deleteTask(service);
      case '5':
        print('Goodbye!');
        return;
      default:
        print('Invalid option.');
    }
  }
}

Future<void> addTask(Taskservice service) async {
  stdout.write('Title: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  if (title.isEmpty) return print('A title is required.');

  stdout.write('Priority (low/medium/high): ');
  final priorityText = stdin.readLineSync()?.trim().toLowerCase();
  final priority = Priority.values
      .where((p) => p.name == priorityText)
      .firstOrNull;
  if (priority == null) {
    return print('Invalid priority. Use low, medium, or high.');
  }

  stdout.write('Deadline (YYYY-MM-DD, optional): ');
  final deadlineText = stdin.readLineSync()?.trim() ?? '';
  final deadline = deadlineText.isEmpty
      ? null
      : DateTime.tryParse(deadlineText);
  if (deadlineText.isNotEmpty && deadline == null) {
    return print('Invalid date. Use YYYY-MM-DD.');
  }

  final Task task = priority == Priority.high
      ? UrgentTask(
          id: DateTime.now().microsecondsSinceEpoch,
          title: title,
          priority: priority,
          deadline: deadline,
        )
      : NormalTask(
          id: DateTime.now().microsecondsSinceEpoch,
          title: title,
          priority: priority,
          deadline: deadline,
        );
  try {
    await service.addTask(task);
    print('Task added.');
  } on DuplicateTaskException catch (error) {
    print(error);
  } on ArgumentError catch (error) {
    print(error.message);
  }
}

Future<void> listTasks(Taskservice service) async {
  final tasks = await service.getAllTasks();
  if (tasks.isEmpty) return print('No tasks found.');
  for (final task in tasks) {
    final date = task.deadline?.toIso8601String().split('T').first ?? 'none';
    print(
      'ID: ${task.id} | ${task.title} | ${task.priority.name} | deadline: $date | ${task.isDone ? 'done' : 'open'}',
    );
  }
}

Future<void> completeTask(Taskservice service) async {
  final id = _readTaskId();
  if (id == null) return;
  try {
    await service.completeTask(id);
    print('Task marked as done.');
  } on TaskNotFoundException catch (error) {
    print(error);
  }
}

Future<void> deleteTask(Taskservice service) async {
  final id = _readTaskId();
  if (id == null) return;
  try {
    await service.deleteTask(id);
    print('Task deleted.');
  } on TaskNotFoundException catch (error) {
    print(error);
  }
}

int? _readTaskId() {
  stdout.write('Task ID: ');
  final id = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  if (id == null) print('Task ID must be a number.');
  return id;
}
