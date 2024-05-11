import 'package:flutter/material.dart';
import 'package:my_todo_app/services/navigate_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QuickTask'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              child: Image.asset('assets/QuickTaskLogo.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => navigateToSignIn(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    child: const Text('Sign In'),
                  ),
                ),
                Container(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => navigateToSignUp(context),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                      child: const Text('Sign Up'),
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ));
  }
}
