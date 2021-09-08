import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditPost extends StatefulWidget {
  final Map data;
  EditPost({required this.data});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late String imagePath;
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  void initState() {
    super.initState();
    titleController.text = widget.data["title"];
    descriptionController.text = widget.data["description"];
  }

  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imagePath = image!.path;
      });
    }

    void done() async {
      try {
        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        FirebaseFirestore db = FirebaseFirestore.instance;

        File file = File(imagePath);
        await ref.putFile(file);
        String downloadesUrl = await ref.getDownloadURL();

        Map<String, dynamic> newPost = {
          "title": titleController.text,
          "description": descriptionController.text,
          "url": downloadesUrl,
        };

        db.collection("post").doc(widget.data["id"]).set(newPost);
        Navigator.of(context).pop();
      } catch (e) {}
    }

    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            ElevatedButton(onPressed: done, child: Text("Done")),
          ],
        ),
      ),
    );
  }
}
