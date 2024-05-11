import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/pages/widgets/user_future_builder.dart';
import 'package:my_todo_app/services/task_service.dart';
import 'package:my_todo_app/services/user_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final taskService = TaskService();
  final userService = UserService();
  ParseUser? currentUser;

  @override
  void initState() {
    super.initState();
    userService.getUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QuickTask'),
        ),
        body: Column(
          children: <Widget>[
            UserFutureBuilder(
              userService: userService,
              currentUser: currentUser,
            ),
            const SizedBox(height: 20),
            Expanded(
                child: FutureBuilder<List<Task>>(
                    future: taskService.getTasks(currentUser?.objectId ?? ''),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center();
                        default:
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error..."),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("No Data..."),
                            );
                          } else {
                            return ListView.builder(
                                padding: const EdgeInsets.only(top: 10.0),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  //*************************************
                                  //Get Parse Object Values
                                  final task = snapshot.data![index];
                                  final varTitle = task.title;
                                  final varDone = task.done;
                                  final varDueDate = task.dueDate;
                                  //*************************************

                                  return ListTile(
                                    title: Text(
                                      varTitle,
                                      style: TextStyle(
                                        decoration: varDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    subtitle: varDueDate == null
                                        ? null
                                        : Text(
                                            'Due Date: ${DateFormat('dd-MMM-yyy').format(tz.TZDateTime.from(varDueDate, tz.local))}',
                                            style: const TextStyle(
                                                color: Colors.pinkAccent),
                                          ),
                                    leading: Checkbox(
                                        value: varDone,
                                        onChanged: (value) async {
                                          task.done = value!;
                                          await taskService.updateTask(task);
                                          setState(() {});
                                        }),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            showEditTaskDialog(context, task);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () async {
                                            await taskService.deleteTask(task);
                                            setState(() {
                                              const snackBar = SnackBar(
                                                content: Text("Task deleted!"),
                                                duration: Duration(seconds: 2),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                      }
                    })),
            Container(
                margin: const EdgeInsets.only(bottom: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        showAddTaskDialog(context);
                      },
                      child: const Text("+", style: TextStyle(fontSize: 40)),
                    )
                  ],
                )),
          ],
        ));
  }

  Future<dynamic> showAddTaskDialog(BuildContext context) {
    DateTime? dueDate;
    final todoController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add a new task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: todoController,
                    decoration: const InputDecoration(
                        hintText: 'Enter your task title (required)'),
                  ),
                  const SizedBox(height: 20),
                  Text(dueDate == null
                      ? 'No date selected'
                      : 'Due Date: ${DateFormat('dd-MMM-yyy').format(dueDate!)}'),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        DateTime now = DateTime.now();
                        dueDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          now.hour,
                          now.minute,
                          now.second,
                          now.millisecond,
                          now.microsecond,
                        );
                      }
                      setState(() {});
                    },
                    child: const Text('Select Due Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    if (todoController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a title'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Task newTask = Task(
                          title: todoController.text,
                          userId: currentUser!.objectId!,
                          dueDate: dueDate);
                      await taskService.saveTask(newTask);
                      Navigator.of(context).pop();
                      this.setState(() {});
                    }
                  },
                  child: const Text('Add'),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final originalDueDate = task.dueDate;
    final titleChangedNotifier = ValueNotifier<bool>(false);
    final dueDateChangedNotifier = ValueNotifier<bool>(false);
    final anyChangedNotifier = ValueNotifier<bool>(false);
    titleController.addListener(() {
      titleChangedNotifier.value = titleController.text != task.title;
      anyChangedNotifier.value =
          titleChangedNotifier.value || dueDateChangedNotifier.value;
    });

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Task title (required)'),
                    onChanged: (value) {
                      titleChangedNotifier.value = value != task.title;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(task.dueDate == null
                      ? 'No date selected'
                      : 'Due Date: ${DateFormat('dd-MMM-yyy').format(task.dueDate!)}'),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: task.dueDate != null &&
                                task.dueDate!.isAfter(DateTime.now())
                            ? task.dueDate!
                            : DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        DateTime now = DateTime.now();
                        task.dueDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          now.hour,
                          now.minute,
                          now.second,
                          now.millisecond,
                          now.microsecond,
                        );
                      }

                      dueDateChangedNotifier.value =
                          task.dueDate != originalDueDate;
                      anyChangedNotifier.value = titleChangedNotifier.value ||
                          dueDateChangedNotifier.value;
                      setState(() {});
                    },
                    child: const Text('Select Due Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                ValueListenableBuilder<bool>(
                    valueListenable: anyChangedNotifier,
                    builder: (context, anyChanged, child) {
                      return ElevatedButton(
                        onPressed: anyChanged
                            ? () async {
                                if (titleController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a title'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  task.title = titleController.text;
                                  await taskService.updateTask(task);
                                  Navigator.of(context).pop();
                                  this.setState(() {});
                                }
                              }
                            : null,
                        child: const Text('Update'),
                      );
                    })
              ],
            );
          },
        );
      },
    );
  }
}
