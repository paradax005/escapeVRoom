import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:flutter/material.dart';

import 'custom_triangle.dart';

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
              child: Text(
                messageDocument['message'],
                style: const TextStyle(color: Colors.white, fontSize: 15),
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
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  messageDocument['sticker'],
                ),
              ),
            ),
          ),
          CustomPaint(painter: Triangle(bubbleOutColor)),
        ],
      ),
    );

    //  Padding(
    //   padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / 5)),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // Transform(
    //       //   alignment: Alignment.center,
    //       //   transform: Matrix4.rotationY(math.pi),
    //       //   child: CustomPaint(
    //       //     painter: Triangle(bubbleOutColor),
    //       //   ),
    //       // ),
    //       Flexible(
    //         child: Container(
    //           padding: const EdgeInsets.all(12),
    //           margin: const EdgeInsets.only(bottom: 5),
    //           decoration: BoxDecoration(
    //             color: bubbleOutColor,
    //             borderRadius: const BorderRadius.only(
    //               topRight: Radius.circular(19),
    //               bottomLeft: Radius.circular(19),
    //               bottomRight: Radius.circular(19),
    //             ),
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 width: 100,
    //                 height: 100,
    //                 child: Image.network(
    //                   messageDocument['sticker'],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       CustomPaint(painter: Triangle(bubbleOutColor)),
    //     ],
    //   ),
    // );
  }
}
