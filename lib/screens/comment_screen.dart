import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/comments_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_mrthods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class CommentsScreen extends StatefulWidget {
  final postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comments'),
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: mobileBackgroundColor,
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${user.userName}',
                        border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.uid,
                  user.userName,
                  user.photoUrl,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) => CommentsCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
            itemCount: (snapshot.data! as dynamic).docs.length,
          );
        },
      ),
    );
  }
}
