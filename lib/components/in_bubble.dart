import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/utils/post_functionality.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'custom_triangle.dart';

class InBubble extends StatelessWidget {
  final DocumentSnapshot messageDocument;
  const InBubble({Key? key, required this.messageDocument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messageDocument['message'] != '') {
      return MessageWidgetIn(messageDocument: messageDocument);
    } else {
      return StickerMessageIn(
        messageDocument: messageDocument,
      );
    }
  }
}

class MessageWidgetIn extends StatelessWidget {
  const MessageWidgetIn({
    Key? key,
    required this.messageDocument,
  }) : super(key: key);

  final DocumentSnapshot messageDocument;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: (MediaQuery.of(context).size.width / 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            child: Image.network(messageDocument['userimage']),
          ),
          const SizedBox(
            width: 6,
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CustomPaint(
              painter: Triangle(blueGreyColor),
            ),
          ),
          Flexible(
            child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: blueGreyColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageDocument['username'],
                      style: TextStyle(
                        color: greenColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      messageDocument['message'],
                      style: TextStyle(color: whiteColor, fontSize: 14),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Provider.of<PostFunctionality>(context, listen: false)
                              .showTimeAgo(
                            messageDocument['time'],
                          ),
                          style: TextStyle(
                            color: yellowColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class StickerMessageIn extends StatelessWidget {
  const StickerMessageIn({
    Key? key,
    required this.messageDocument,
  }) : super(key: key);

  final DocumentSnapshot messageDocument;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: (MediaQuery.of(context).size.width / 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            child: Image.network(messageDocument['userimage']),
          ),
          const SizedBox(
            width: 6,
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CustomPaint(
              painter: Triangle(blueGreyColor),
            ),
          ),
          Flexible(
            child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: blueGreyColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageDocument['username'],
                      style: TextStyle(
                        color: greenColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        messageDocument['sticker'],
                      ),
                    ),
                    Text(
                      Provider.of<PostFunctionality>(context, listen: false)
                          .showTimeAgo(
                        messageDocument['time'],
                      ),
                      style: TextStyle(
                        color: yellowColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
