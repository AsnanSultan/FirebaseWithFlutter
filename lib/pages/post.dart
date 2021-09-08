import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_with_flutter/pages/editPost.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  final Map data;
  Post({
    Key? key,
    required this.data,
  }) : super(key: key);

  Stream collectionStream =
      FirebaseFirestore.instance.collection('post').snapshots();

  void deletePoste() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("post").doc(data["id"]).delete();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    void editPost() {
      showDialog(
          context: context,
          builder: (BuildContext contaxt) {
            return EditPost(
              data: data,
            );
          });
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Image.network(
            data['url'],
            width: 100,
            height: 100,
          ),
          Text(data['title']),
          Text(data['description']),
          ElevatedButton(onPressed: deletePoste, child: Text("Delete")),
          ElevatedButton(onPressed: editPost, child: Text("Edit")),
        ],
      ),
    );
  }
}
