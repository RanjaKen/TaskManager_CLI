import 'dart:convert';
import 'dart:io';

import 'package:taskmanagercli/data/data.dart';
import 'package:taskmanagercli/models/task.dart';

class Taskdata implements Data<Task> {
  final String filePath;

  Taskdata(this.filePath);

  @override
  Future<void> save(List<Task> items) async {
    final file = File(filePath);

    final jsonData = items.map((task) => task.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  @override
  Future<List<Task>> load() async {
    final file = File(filePath);

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();

    if (content.isEmpty) {
      return [];
    }

    final List<dynamic> jsonData = jsonDecode(content) as List<dynamic>;

    return jsonData.map((json) => Task.fromJson(json)).toList();
  }
}
