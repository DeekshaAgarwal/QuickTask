import 'package:flutter/material.dart';
import 'package:my_todo_app/services/user_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserFutureBuilder extends StatelessWidget {
  final UserService userService;
  final ParseUser? currentUser;

  UserFutureBuilder({required this.userService, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParseUser?>(
        future: userService.getUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator()),
              );
            default:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hello, ${snapshot.data!.username}!'),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Logout'),
                          onPressed: () =>
                              userService.logOutUser(context, currentUser!),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        });
  }
}
