import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController emailController =
      new TextEditingController(text: "asnan.sultan676@gmail.com");
  final TextEditingController passwordController =
      new TextEditingController(text: "asnan676");

  void login(var context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    final String email = emailController.text;
    final String password = passwordController.text;
    try {
      final UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final DocumentSnapshot snapshot =
          await db.collection("users").doc(user.user!.uid).get();
      final data = snapshot.data();
      Navigator.of(context).pushNamed("/home");
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: Text("worng Id or password"));
          });
    }
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
              controller: emailController,
              decoration: InputDecoration(labelText: "Enter your Email"),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Enter your Password"),
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text("Login"),
            )
          ],
        )),
      ),
    );
  }
}
