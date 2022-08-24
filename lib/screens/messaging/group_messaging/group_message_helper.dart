// ignore_for_file: slash_for_doc_comments, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../components/in_bubble.dart';
import '../../../components/out_bubble.dart';

class GroupMessageHelper with ChangeNotifier {
  /**
   * Attributes and Getterss !
   */
  bool hasMemberJoined = false;
  bool get getHasMemberJoined => hasMemberJoined;

  late String lastMessageTime;
  String get getLastMessageTime => lastMessageTime;
  /**
   *  Methodes ! 
   */
  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController controller) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': controller.text,
      'sticker': '',
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'username': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserImage,
    }).whenComplete(() {
      controller.clear();
    });
  }

  fetchMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            padding: const EdgeInsets.all(12),
            reverse: true,
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              return SizedBox(
                child: (documentSnapshot['useruid'] ==
                        Provider.of<Authentication>(context, listen: false)
                            .getUserId)
                    ? OutBubble(messageDocument: documentSnapshot)
                    : InBubble(messageDocument: documentSnapshot),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future checkIfJoined(
    BuildContext context,
    String chatRoomName,
    String chatRoomAdminUid,
  ) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((member) {
      hasMemberJoined = false;
      if (member['joined'] != null) {
        hasMemberJoined = member['joined'];
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserId ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkColor,
          title: Text(
            'Join $roomName ? ',
            style: TextStyle(
              color: whiteColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                  decorationColor: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MaterialButton(
              color: blueColor,
              child: Text(
                'Yes',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(roomName)
                    .collection('members')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserId)
                    .set({
                  'joined': true,
                  'username':
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .getInitUserName,
                  'useremail':
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .getInitUserEmail,
                  'userimage':
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .getInitUserImage,
                  'useruid': Provider.of<Authentication>(context, listen: false)
                      .getUserId,
                  'time': Timestamp.now()
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  showSticker(BuildContext context, String chatRoomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: darkColor,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.47,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stickers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot documentSnapshot) {
                              return InkWell(
                                onTap: () async {
                                  sendStickers(
                                    context,
                                    documentSnapshot['url'].toString(),
                                    chatRoomId,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Image.network(
                                    documentSnapshot['url'],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  sendStickers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(
        {
          'message': '',
          'sticker': stickerImageUrl,
          'time': Timestamp.now(),
          'useruid':
              Provider.of<Authentication>(context, listen: false).getUserId,
          'username': Provider.of<FirebaseOperation>(context, listen: false)
              .getInitUserName,
          'userimage': Provider.of<FirebaseOperation>(context, listen: false)
              .getInitUserImage,
        },
      ).whenComplete(() {
        Navigator.pop(context);
      });
    } catch (e) {
      print('error occured => $e');
    }
  }

  String showLastMessage(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print('TimeAgo => $lastMessageTime');
    notifyListeners();

    return lastMessageTime;
  }

  leaveTheGroup(BuildContext context, String chatRoomName,
      DocumentSnapshot documentSnapshot) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkColor,
          title: Text(
            'Leave $chatRoomName?',
            style: TextStyle(
              color: whiteColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                  decorationColor: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MaterialButton(
              color: redColor,
              child: Text(
                'Yes',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(documentSnapshot.id)
                    .collection('members')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserId)
                    .delete()
                    .whenComplete(() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  print('Sucessfully leaved the room ! ');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
