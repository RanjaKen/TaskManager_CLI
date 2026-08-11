

import 'dart:io';

import 'package:taskmanagercli/data/data.dart';
import 'package:taskmanagercli/data/taskData.dart';
import 'package:taskmanagercli/models/normalTask.dart';
import 'package:taskmanagercli/models/priority.dart';
import 'package:taskmanagercli/models/task.dart';
import 'package:taskmanagercli/models/urgentTask.dart';
import 'package:taskmanagercli/repo/taskRepository.dart';
import 'package:taskmanagercli/services/taskService.dart';

Future<void> main(List<String> arguments) async {
  final data = Taskdata('tasks.json');

  final repository = Taskrepository(data);

  final service = Taskservice(repository);

  while (true) {
    print("\n==========================");
    print("       TASK MANAGER");
    print("==========================");
    print("1. Ajouter une tâche");
    print("2. Afficher les tâches");
    print("3. Terminer une tâche");
    print("4. Supprimer une tâche");
    print("5. Quitter");
    print("==========================");

    stdout.write("Votre choix : ");

    final choice = stdin.readLineSync();

    switch (choice) {
      case "1":
        await addTask(service);
        break;

      case "2":
        await listTasks(service);
        break;

      case "3":
        await completeTask(service);
        break;

      case "4":
        await deleteTask(service);
        break;

      case "5":
        print("Au revoir !");
        exit(0);

      default:
        print("Choix invalide.");
    }
  }
}

Future<void> addTask(Taskservice service) async {
  stdout.write("Titre : ");
  final title = stdin.readLineSync()!;

  stdout.write("Priorité (low/medium/high) : ");
  final priorityInput = stdin.readLineSync();

  final priority = Priority.values.firstWhere(
    (p) => p.name == priorityInput,
    orElse: () => Priority.low,
  );

  stdout.write("Date limite (YYYY-MM-DD ou vide) : ");
  final dateInput = stdin.readLineSync();

  DateTime? dueDate;

  if (dateInput != null && dateInput.isNotEmpty) {
    dueDate = DateTime.parse(dateInput);
  }

  Task task;

  if (priority == Priority.high) {
    task = UrgentTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      deadline: dueDate,
      priority: priority,
    );
  } else {
    task = NormalTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      deadline: dueDate,
      isDone: false,
    );
  }

  await service.addTask(task);

  print("Tâche ajoutée !");
}

Future<void> listTasks(Taskservice service) async {
  final tasks = await service.getAllTasks();

  if (tasks.isEmpty) {
    print("Aucune tâche.");
    return;
  }

  print("\n----- Tâches -----");

  for (final task in tasks) {
    print("""
            ID : ${task.id}
            Titre : ${task.title}
            Priorité : ${task.priority.name}
            Date : ${task.deadline ?? "aucune"}
            Statut : ${task.isDone ? "Terminée" : "En cours"}
            ---------------------
""");
  }
}

Future<void> completeTask(Taskservice service) async {
  stdout.write("ID de la tâche : ");

  final id = int.parse(stdin.readLineSync()!);

  await service.completeTask(id);

  print("Tâche terminée !");
}

Future<void> deleteTask(Taskservice service) async {
  stdout.write("ID de la tâche : ");

  final id = int.parse(stdin.readLineSync()!);

  await service.deleteTask(id as String);

  print("Tâche supprimée !");
}
