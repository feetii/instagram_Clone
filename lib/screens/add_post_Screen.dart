import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_mrthods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == "succes") {
        setState(() {
          _isLoading = false;
        });
        clearImage();
        showSnackBar(context, 'Posted');
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Creat Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Chose frome Gellery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Concel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  /* Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });*/
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }
 void clearImage()
 {
   setState(() {
     _file = null;
   });
 }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => _selectImage(context),
                icon: const Icon(Icons.upload)),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.userName, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : Padding(padding: EdgeInsets.only(top: 0)),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: 'Write a Caption...'),
                        maxLines: 1,
                        controller: _descriptionController,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter))),
                      ),
                    ),
                    Divider()
                  ],
                )
              ],
            ),
          );
  }
}
