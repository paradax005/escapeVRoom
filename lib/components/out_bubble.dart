import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/utils/post_functionality.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_triangle.dart';
import 'package:timeago/timeago.dart' as timeago;

class OutBubble extends StatefulWidget {
  final DocumentSnapshot messageDocument;
  const OutBubble({Key? key, required this.messageDocument}) : super(key: key);

  @override
  State<OutBubble> createState() => _OutBubbleState();
}

class _OutBubbleState extends State<OutBubble> {
  @override
  Widget build(BuildContext context) {
    try {
      if (widget.messageDocument['message'] != '') {
        return MessageWidgetOut(messageDocument: widget.messageDocument);
      } else {
        return StickerMessageOut(messageDocument: widget.messageDocument);
      }
    } catch (e) {
      return Container();
    }
  }
}

class MessageWidgetOut extends StatelessWidget {
  const MessageWidgetOut({
    Key? key,
    required this.messageDocument,
  }) : super(key: key);

  final DocumentSnapshot messageDocument;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: bubbleOutColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                  bottomRight: Radius.circular(19),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    messageDocument['message'],
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    Provider.of<PostFunctionality>(context, listen: false)
                        .showTimeAgo(
                      messageDocument['time'],
                    ),
                    style: TextStyle(
                      color: yellowColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomPaint(painter: Triangle(bubbleOutColor)),
        ],
      ),
    );
  }
}

class StickerMessageOut extends StatelessWidget {
  const StickerMessageOut({
    Key? key,
    required this.messageDocument,
  }) : super(key: key);

  final DocumentSnapshot messageDocument;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: bubbleOutColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                  bottomRight: Radius.circular(19),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
              ),
            ),
          ),
          CustomPaint(painter: Triangle(bubbleOutColor)),
        ],
      ),
    );
  }

  static String messageTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    String timeAgoMessageSent = timeago.format(dateTime);

    return timeAgoMessageSent;
  }
}
