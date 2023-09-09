import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class CommentsCard extends StatefulWidget {
  final snap;
  const CommentsCard({super.key,required this.snap});

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
               widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text:  widget.snap['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:  '  ${widget.snap['text']}',
                    )
                  ])),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(fontSize: 12, color: secondaryColor),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.favorite,size: 16,),
          )
        ],
      ),
    );
  }
}
