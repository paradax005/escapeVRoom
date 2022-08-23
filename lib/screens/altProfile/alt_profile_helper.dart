import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/messaging/direct_messaging/chat_message.dart';
import 'package:escaperoom/screens/profile/profile_helper.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'alt_profile.dart';

class AltProfileHelper with ChangeNotifier {
  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: whiteColor,
          ),
          onPressed: () {},
        ),
      ],
      title: RichText(
        text: TextSpan(
          text: 'Escape',
          style: TextStyle(
            color: whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: 'Room',
              style: TextStyle(
                color: redColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUID) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 55.0,
                        // backgroundImage: AssetImage('assets/images/avatar1.png'),
                        backgroundImage:
                            NetworkImage(snapshot.data!['userimage'] ?? ''),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data!['username'] ?? '',
                        // "username",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: greenColor,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            snapshot.data!['useremail'] ?? '',
                            // "useremail here",
                            textScaleFactor: 0.8,
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  // color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowersSheet(context, snapshot);
                            },
                            child: Container(
                              height: 70,
                              width: 80,
                              decoration: BoxDecoration(
                                color: darkColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['userId'])
                                        .collection('followers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28.0,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                              color: darkColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data!['userId'])
                                      .collection('following')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28.0,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 70,
                        width: 80,
                        decoration: BoxDecoration(
                          color: darkColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    Provider.of<FirebaseOperation>(context, listen: false)
                        .followUser(
                      userUID,
                      Provider.of<Authentication>(context, listen: false)
                          .getUserId,
                      {
                        'username': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getInitUserName,
                        'useremail': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getInitUserEmail,
                        'userimage': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getInitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId,
                        'time': Timestamp.now(),
                      },
                      Provider.of<Authentication>(context, listen: false)
                          .getUserId,
                      userUID,
                      {
                        'username': snapshot.data!['username'],
                        'useremail': snapshot.data!['useremail'],
                        'userimage': snapshot.data!['userimage'],
                        'useruid': snapshot.data!['userId'],
                        'time': Timestamp.now(),
                      },
                    )
                        .whenComplete(() {
                      followedNotification(
                          context, 'Following ${snapshot.data!['username']}');
                    });
                  },
                  color: blueColor,
                  child: Text(
                    'Follow',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userUID)
                        .get()
                        .then((DocumentSnapshot document) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatMessage(
                            userDocument: document,
                          ),
                        ),
                      );
                    });
                  },
                  color: blueColor,
                  child: Text(
                    'Message',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
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

  Widget divider(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 25.0,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Divider(
          color: whiteColor,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: yellowColor,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Recently Added',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: yellowColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, String userUID) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userUID)
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                    onTap: () {
                      Provider.of<ProfileHelper>(context, listen: false)
                          .showPostDetails(context, documentSnapshot);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: FittedBox(
                        child: Image.network(
                          documentSnapshot['postimage'],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  followedNotification(BuildContext context, String message) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: blueGreyColor.withOpacity(0.4),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!['userId'])
                  .collection('followers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListTile(
                          onTap: () {
                            if (documentSnapshot['useruid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId) {
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
                          trailing: documentSnapshot['useruid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserId
                              ? MaterialButton(
                                  onPressed: () {},
                                  color: blueColor,
                                  child: Text(
                                    'Unfollow',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(documentSnapshot['userimage']),
                          ),
                          title: Text(
                            documentSnapshot['username'],
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }
}
