import 'package:my_todo_app/models/task.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskService {
  Future<void> saveTask(Task task) async {
    await task.toParseObject().save();
  }

  Future<List<Task>> getTasks(String userId) async {
    QueryBuilder<ParseObject> queryTask =
        QueryBuilder<ParseObject>(ParseObject('Todo'))
          ..whereEqualTo('userId', userId);

    final ParseResponse apiResponse = await queryTask.query();

    if (apiResponse.success && apiResponse.results != null) {
      return (apiResponse.results as List<ParseObject>)
          .map(Task.fromParseObject)
          .toList();
    } else {
      return [];
    }
  }

  Future<void> updateTask(Task task) async {
    await task.toParseObject().save();
  }

  Future<void> deleteTask(Task task) async {
    await task.toParseObject().delete();
  }
}
