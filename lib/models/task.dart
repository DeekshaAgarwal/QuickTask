import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String id;
  String title;
  String userId;
  DateTime? dueDate;
  bool done;

  // Constructor for creating a new Task
  Task({
    required this.title,
    required this.userId,
    this.dueDate,
    this.done = false,
  }) : id = '';

  // Method to set the id after the Task has been saved to the server
  void setId(String id) {
    this.id = id;
  }

  // Factory constructor
  factory Task.fromParseObject(ParseObject parseObject) {
    return Task(
      title: parseObject.get<String>('title')!,
      userId: parseObject.get<String>('userId')!,
      dueDate: parseObject.get<DateTime>('dueDate'),
      done: parseObject.get<bool>('done')!,
    )..setId(parseObject.objectId!);
  }

  ParseObject toParseObject() {
    var todo = ParseObject('Todo')
      ..set('title', title)
      ..set('userId', userId)
      ..set('dueDate', dueDate)
      ..set('done', done);

    if (id.isNotEmpty) {
      todo.objectId = id;
    }

    return todo;
  }
}
