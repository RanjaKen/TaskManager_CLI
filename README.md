# Task Manager CLI

A task management command-line app built with pure Dart 

## Features

* Add tasks with a title, `low`/`medium`/`high` priority, and an optional deadline
* List tasks sorted by priority and then deadline
* Mark tasks as done and delete tasks by ID
* Persist tasks in the local `tasks.json` file
* Report invalid input and missing or duplicate task IDs clearly

## Technical design

* `Task` is an abstract class, extended by `NormalTask` and `UrgentTask`.
* `Repository<T>` and `Data<T>` are generic abstractions; `Taskrepository` implements `Repository<Task>`.
* `taskService` is an interface implemented by `Taskservice`.
* `TaskNotFoundException` and `DuplicateTaskException` are custom exceptions.

## Requirements

* Dart SDK 3 or later

## Run

```bash
dart pub get
dart run bin/taskmanagercli.dart
```

## Test

```bash
dart test
```

The suite includes more than five unit tests covering add, duplicate IDs, deletion, missing tasks, completion, and sorting.

## Data file

The app creates and updates `tasks.json` in the project root. A task is stored like this:

```json
{
  "id": 1,
  "title": "Learn Dart",
  "priority": "high",
  "deadline": "2026-08-20T00:00:00.000",
  "isDone": false,
  "createdAt": "2026-08-14T10:00:00.000"
}
```
