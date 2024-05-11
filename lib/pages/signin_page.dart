import 'package:flutter/material.dart';
import 'package:my_todo_app/services/user_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final userService = UserService();

  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign In to QuickTask'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset('assets/QuickTaskLogo.png'),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text('Welcome to QuickTask!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: usernameController,
                  enabled: !isLoggedIn,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Username'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: passwordController,
                  enabled: !isLoggedIn,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Password'),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoggedIn
                        ? null
                        : () => userService.loginUser(
                            context, usernameController, passwordController),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    child: const Text('Log In'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
