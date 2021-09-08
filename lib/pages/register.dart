import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  void register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await db
          .collection("users")
          .doc(user.user!.uid)
          .set({"email": email, "username": username});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: SafeArea(
            child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Enter your Username"),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Enter your Email"),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Enter your Password"),
            ),
            ElevatedButton(
              onPressed: register,
              child: Text("Register"),
            )
          ],
        )),
      ),
    );
  }
}
