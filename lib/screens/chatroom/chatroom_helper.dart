import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/screens/messaging/group_message.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';
import '../altProfile/alt_profile.dart';

class ChatRoomHelper with ChangeNotifier {
  TextEditingController chatRoomController = TextEditingController();

  String chatRoomAvatarUrl = "";
  String chatRoomId = "";

  String get getChatRoomAvatarUrl => chatRoomAvatarUrl;
  String get getChatRoomId => chatRoomId;

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: 'Chat',
          style: TextStyle(
            color: whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: 'Box',
              style: TextStyle(
                color: blueColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: whiteColor,
          ),
          onPressed: () {},
        ),
      ],
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          EvaIcons.plus,
          color: greenColor,
          size: 28,
        ),
      ),
    );
  }

  showCreateChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.27,
              decoration: BoxDecoration(
                color: blueGreyColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Divider(
                      thickness: 3,
                      color: whiteColor,
                    ),
                  ),
                  Text(
                    'Select ChatRoom Avatar ',
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatAvatars')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatRoomAvatarUrl = documentSnapshot['uri'];
                                  notifyListeners();
                                  print(chatRoomAvatarUrl);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  height: 40,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    border: chatRoomAvatarUrl ==
                                            documentSnapshot['uri']
                                        ? Border.all(
                                            color: greenColor,
                                          )
                                        : null,
                                  ),
                                  child: Image.network(documentSnapshot['uri']),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: chatRoomController,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter ChatRoom name',
                            hintStyle: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .submitChatRoomData(
                            chatRoomController.text,
                            {
                              'roomavatar': getChatRoomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatRoomController.text,
                              'username': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'useremail': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'userimage': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                            },
                          ).whenComplete(() {
                            Navigator.pop(context);
                            chatRoomController.clear();
                          });
                        },
                        backgroundColor: greenColor.withOpacity(0.8),
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  fetchChatRooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: blueGreyColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: ListTile(
                  onLongPress: () {
                    showChatRoomDetails(context, documentSnapshot);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupMessage(
                          chatDocuemnt: documentSnapshot,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(documentSnapshot['roomavatar']),
                  ),
                  title: Text(
                    documentSnapshot['roomname'],
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'last message',
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    '2 hours ago',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  showChatRoomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: blueColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      "Members",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId !=
                                    documentSnapshot['useruid']) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AltProfile(
                                        userID: documentSnapshot['useruid'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: darkColor,
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['userimage']),
                                    ),
                                    Text(
                                      documentSnapshot['username'],
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  width: 110,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: yellowColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      "Admin",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        documentSnapshot['username'],
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
