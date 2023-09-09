import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_mrthods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;

  PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  bool isLikAnimating = false;
  int commentLen=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }
  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts')
          .doc(widget.snap['postId']).collection('comments')
          .get();
       commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    final User user = Provider
        .of<UserProvider>(context)
        .getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )), widget.snap['uid'].toString() == user.uid  ?
                IconButton(
                    onPressed: () {
                      showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((e) =>
                                    InkWell(
                                      onTap: () {
                                        deletePost(
                                          widget.snap['postId']
                                              .toString(),
                                        );
                                        // remove the dialog box
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ))
                                    .toList(),
                              ),
                            );
                          }
                      );

                    },
                    icon: Icon(Icons.more_vert)
                ):Container()
              ],
            ),
            //imageSction
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.35,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.snap['postUrl'],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isLikAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                  isAnimating: isLikAnimating,
                  duration: Duration(milliseconds: 500),
                  onEnd: () {
                    setState(() {
                      isLikAnimating = false;
                    });
                  },
                ),
              )
            ]),
          ),

          //likeComment
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: widget.snap['likes'].contains(user.uid)
                          ? Colors.red
                          : Colors.white,
                    )),
              ),
              IconButton(
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(
                                postId: widget.snap['postId'].toString(),
                              ))),
                  icon: Icon(
                    Icons.comment_outlined,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  )),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                        )),
                  ))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                      '${(widget.snap['likes'].length).toString()} likes',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '   ${widget.snap['description']}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all $commentLen comments',
                      style: TextStyle(fontSize: 14, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
