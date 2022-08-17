// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GroupMessageHelper with ChangeNotifier {
  /**
   * Attributes and Getterss !
   */
  bool hasMemberJoined = false;
  bool get getHasMemberJoined => hasMemberJoined;
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
      'sticker' : '',
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
            reverse: true,
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.13,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0, top: 20),
                      child: Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: double.infinity,
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId ==
                                      documentSnapshot['useruid']
                                  ? blueGreyColor.withOpacity(0.8)
                                  : blueGreyColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Text(
                                          documentSnapshot['username'],
                                          style: TextStyle(
                                            color: greenColor,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        documentSnapshot['useruid'] ==
                                                adminUserId
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Icon(
                                                  FontAwesomeIcons.chessKing,
                                                  color: yellowColor,
                                                  size: 12,
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 0.0,
                                                width: 0.0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    documentSnapshot['message'],
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 10,
                        child:
                            Provider.of<Authentication>(context, listen: false)
                                        .getUserId ==
                                    documentSnapshot['useruid']
                                ? SizedBox(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: blueColor,
                                            size: 18.0,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            FontAwesomeIcons.trashCan,
                                            color: redColor,
                                            size: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0.0,
                                    height: 0.0,
                                  )),
                    Positioned(
                      left: 40,
                      top: 8,
                      child: Provider.of<Authentication>(context, listen: false)
                                  .getUserId ==
                              documentSnapshot['useruid']
                          ? const SizedBox(
                              width: 0.0,
                              height: 0.0,
                            )
                          : SizedBox(
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: blueGreyColor,
                                backgroundImage: NetworkImage(
                                  documentSnapshot['userimage'],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
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
      print('initial state => $hasMemberJoined');
      if (member['joined'] != null) {
        hasMemberJoined = member['joined'];
        print('final state => $hasMemberJoined');
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

  showSticker(BuildContext context) {
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
                )),
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
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return InkWell(
                              onTap: () async {
                                print(
                                    'Stickers url => ${documentSnapshot['url'].toString()}');
                                // sendStickers(context, documentSnapshot['url'].toString(),
                                //     chatRoomId);
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Image.network(
                                  documentSnapshot['url'],
                                ),
                              ),
                            );
                          }).toList(),
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
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(
      {
        'message' : '',
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
      print('Stickers send successfully to firestore ! ');
      Navigator.pop(context);
    });
  }
}
