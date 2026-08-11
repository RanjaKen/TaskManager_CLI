class TaskNotFoundException implements Exception {
  final int id;

  TaskNotFoundException(this.id);

  @override
  String toString() => "Task with ID $id not found.";
}

