class DuplicateTaskException implements Exception {
  final int id;

  DuplicateTaskException(this.id);

  @override
  String toString() => "Task with ID $id already exists.";
}
