# Task Manager CLI

A simple command-line task manager built with **Dart 3**.

## Features

* Add a task
* List all tasks
* Mark a task as completed
* Delete a task
* Set task priority: `low`, `medium`, `high`
* Add an optional deadline
* Save tasks in a local JSON file
* Unit tests

## Requirements

* Dart 3 or higher

Check Dart:

```bash
dart --version
```

## Installation

Clone the project:

```bash
git clone https://github.com/YOUR_USERNAME/taskmanagercli.git
```

Go to the project:

```bash
cd taskmanagercli
```

Install dependencies:

```bash
dart pub get
```

## Run the application

```bash
dart run bin/main.dart
```

## Example

The application displays:

```text
==========================
       TASK MANAGER
==========================
1. Ajouter une tâche
2. Afficher les tâches
3. Terminer une tâche
4. Supprimer une tâche
5. Quitter
```

### Add a task

```text
Titre : Learn Dart
Priorité : high
Date limite : 2026-08-20
```

### List tasks

```text
ID : 1
Titre : Learn Dart
Priorité : high
Deadline : 2026-08-20
Statut : En cours
```

## Data

Tasks are saved in:

```text
data/tasks.json
```

Example:

```json
[
  {
    "id": "1",
    "title": "Learn Dart",
    "priority": "high",
    "deadline": null,
    "isDone": false
  }
]
```


## Architecture

```text
CLI
 ↓
TaskService
 ↓
TaskRepository
 ↓
TaskData
 ↓
tasks.json
```





## Author

**Andi Andriamalala**

Dart CLI Task Manager Project

