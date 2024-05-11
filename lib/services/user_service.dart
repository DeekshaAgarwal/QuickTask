import 'package:flutter/material.dart';
import 'package:my_todo_app/pages/home_page.dart';
import 'package:my_todo_app/pages/signin_page.dart';
import 'package:my_todo_app/services/navigate_service.dart';
import 'package:my_todo_app/utils/message.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserService {
  Future<ParseUser?> getUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }

  void loginUser(BuildContext context, TextEditingController usernameController,
      TextEditingController passwordController) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      navigateToUser(context);
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }

  void registerUser(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController emailController) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Perform validations
    if (username.isEmpty) {
      Message.showError(context: context, message: 'Username cannot be empty');
      return;
    }

    RegExp regexEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email.isEmpty || !email.contains('@') || !regexEmail.hasMatch(email)) {
      Message.showError(
          context: context, message: 'Please enter a valid email');
      return;
    }

    if (password.isEmpty || password.length < 8) {
      Message.showError(
          context: context,
          message: 'Password must be at least 8 characters long');
      return;
    }

    // Check for at least one uppercase letter, one lowercase letter, one number and one special character
    RegExp regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!regex.hasMatch(password)) {
      Message.showError(
          context: context,
          message:
              'Password must contain at least one uppercase letter, one lowercase letter, one number and one special character');
      return;
    }

    if (await userExists(username)) {
      Message.showError(context: context, message: 'Username already exists');
    } else {
      var user = ParseUser.createUser(username, password, email);
      var response = await user.signUp();

      if (response.success) {
        Message.showSuccess(
            context: context,
            message: 'User signed up successfully!',
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
                (Route<dynamic> route) => false,
              );
            });
      } else {
        Message.showError(context: context, message: response.error!.message);
      }
    }
  }

  Future<bool> userExists(String username) async {
    var queryBuilder = QueryBuilder(ParseUser.forQuery())
      ..whereEqualTo("username", username);

    var response = await queryBuilder.query();

    return response.results != null && response.results!.isNotEmpty;
  }

  void logOutUser(BuildContext context, ParseUser currentUser) async {
    var response = await currentUser!.logout();
    if (response.success) {
      Message.showSuccess(
          context: context,
          message: 'User was successfully logged out!',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          });
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }
}
