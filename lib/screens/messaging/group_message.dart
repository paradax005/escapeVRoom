import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/messaging/group_message_helper.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot chatDocuemnt;
  const GroupMessage({
    Key? key,
    required this.chatDocuemnt,
  }) : super(key: key);

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // Ask to join the Room !!
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIfJoined(
      context,
      widget.chatDocuemnt.id,
      widget.chatDocuemnt['useruid'],
    )
        .whenComplete(() {
      if (!Provider.of<GroupMessageHelper>(context, listen: false)
          .getHasMemberJoined) {
        Timer(
          const Duration(milliseconds: 10),
          () =>
              Provider.of<GroupMessageHelper>(context, listen: false).askToJoin(
            context,
            widget.chatDocuemnt.id,
          ),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor.withOpacity(0.6),
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserId ==
                  widget.chatDocuemnt['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: whiteColor,
                  ),
                )
              : const SizedBox(
                  width: 0.0,
                  height: 0.0,
                ),
          IconButton(
            onPressed: () {
              Provider.of<GroupMessageHelper>(context, listen: false)
                  .leaveTheGroup(
                context,
                widget.chatDocuemnt['roomname'],
                widget.chatDocuemnt,
              );
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: redColor,
            ),
          ),
        ],
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.chatDocuemnt['roomavatar'],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatDocuemnt['roomname'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(widget.chatDocuemnt.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            snapshot.data!.docs.length.toInt() == 1
                                ? '${snapshot.data!.docs.length.toString()} member'
                                : '${snapshot.data!.docs.length.toString()} members',
                            style: TextStyle(
                              color: greenColor.withOpacity(0.5),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              AnimatedContainer(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.82,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .fetchMessage(context, widget.chatDocuemnt,
                        widget.chatDocuemnt['useruid']),
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
                        onPressed: () {
                          Provider.of<GroupMessageHelper>(context,
                                  listen: false)
                              .showSticker(context, widget.chatDocuemnt.id);
                        },
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
                          if (messageController.text.isNotEmpty) {
                            Provider.of<GroupMessageHelper>(context,
                                    listen: false)
                                .sendMessage(context, widget.chatDocuemnt,
                                    messageController);
                          }
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
        ),
      ),
    );
  }
}
