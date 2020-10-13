import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../signInWithGoogle.dart';
import 'authentication_service.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: Text("Sign Up"),
            )
          ],
        ),

      ),
    );
  }
}
