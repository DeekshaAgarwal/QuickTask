import 'package:flutter/material.dart';
import 'package:my_todo_app/pages/signin_page.dart';
import 'package:my_todo_app/pages/signup_page.dart';
import 'package:my_todo_app/pages/user_task_page.dart';

void navigateToUser(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const UserPage()),
    (Route<dynamic> route) => false,
  );
}

void navigateToSignUp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignUpPage()),
  );
}

void navigateToSignIn(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignInPage()),
  );
}
