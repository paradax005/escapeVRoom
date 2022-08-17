import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/messaging/group_message_helper.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMessage extends StatelessWidget {
  final DocumentSnapshot chatDocuemnt;
  GroupMessage({
    Key? key,
    required this.chatDocuemnt,
  }) : super(key: key);
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor.withOpacity(0.6),
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserId ==
                  chatDocuemnt['useruid']
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
            onPressed: () {},
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
                  chatDocuemnt['roomavatar'],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatDocuemnt['roomname'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '6 members',
                      style: TextStyle(
                        color: greenColor.withOpacity(0.5),
                        fontSize: 12.0,
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
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              AnimatedContainer(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .fetchMessage(
                        context, chatDocuemnt, chatDocuemnt['useruid']),
              ),
              Container(
                decoration: BoxDecoration(
                  color: darkColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type a message ...',
                          hintStyle: TextStyle(
                            color: whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: blueColor.withOpacity(0.8),
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          Provider.of<GroupMessageHelper>(context,
                                  listen: false)
                              .sendMessage(
                                  context, chatDocuemnt, messageController);
                        }
                      },
                      child: Icon(
                        Icons.send_sharp,
                        color: whiteColor,
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
