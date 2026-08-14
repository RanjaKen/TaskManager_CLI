import 'package:taskmanagercli/models/priority.dart';
import 'package:taskmanagercli/models/task.dart';

class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    required super.priority,
    super.isDone,
    super.deadline,
    super.createdAt,
  }) : assert(priority != Priority.high);

  @override
  void showDetails() {
    print('''[Normal TASK]
            Title: $title
            Priority: $priority.capitalize()
            Due Date: ${deadline?.toIso8601String() ?? 'No due date'}
            Status: ${isDone ? 'Completed' : 'Not Completed'}
          ''');
  }
}
