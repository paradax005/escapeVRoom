import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GroupMessageHelper with ChangeNotifier {
  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController controller) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': controller.text,
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
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
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
                                backgroundColor: blueGreyColor,
                                backgroundImage: NetworkImage(
                                  documentSnapshot['userimage'],
                                  scale: 0.4,
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
}
