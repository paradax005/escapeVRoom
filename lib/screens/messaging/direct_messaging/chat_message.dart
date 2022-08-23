import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/screens/messaging/direct_messaging/chat_message_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../constants/appcolors.dart';

class ChatMessage extends StatefulWidget {
  final DocumentSnapshot userDocument;
  const ChatMessage({
    Key? key,
    required this.userDocument,
  }) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor.withOpacity(0.6),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.userDocument['userimage'],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userDocument['username'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Container(
            decoration: BoxDecoration(
              color: darkColor.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: whiteColor.withOpacity(0.4),
                  offset: const Offset(0.0, 0.0), //(x,y)
                  blurRadius: 0.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_sharp,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    controller: messageController,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      fillColor: whiteColor,
                      hintText: 'Type a message ...',
                      hintStyle: TextStyle(
                        color: whiteColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: whiteColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: whiteColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.06,
                  child: FloatingActionButton(
                    backgroundColor: bubbleOutColor,
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {}
                    },
                    child: Icon(
                      Icons.send_sharp,
                      color: whiteColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
