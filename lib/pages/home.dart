import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_with_flutter/pages/post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  Stream<QuerySnapshot> postStream =
      FirebaseFirestore.instance.collection('post').snapshots();

  String imagePath = "";
  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image!.path;
      });
    }

    void submitPost() async {
      try {
        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        FirebaseFirestore db = FirebaseFirestore.instance;
        final String title = titleController.text;
        final String des = descriptionController.text;

        File file = File(imagePath);
        await ref.putFile(file);
        String downloadesUrl = await ref.getDownloadURL();

        await db
            .collection("post")
            .add({"url": downloadesUrl, "title": title, "description": des});
        print("file uploaded");
      } catch (e) {
        print("Error");
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Enter Title"),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Enter description"),
            ),
            ElevatedButton(onPressed: pickImage, child: Text("Pic an Image")),
            ElevatedButton(onPressed: submitPost, child: Text("Submitte")),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: SafeArea(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: postStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          String id = document.id;
                          data["id"] = id;
                          return Post(data: data);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
