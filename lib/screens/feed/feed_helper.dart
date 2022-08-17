import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/models/post.dart';
import 'package:escaperoom/screens/altProfile/alt_profile.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:escaperoom/utils/post_functionality.dart';
import 'package:escaperoom/utils/upload_post.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class FeedHelpers with ChangeNotifier {
  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.camera_enhance_rounded, color: greenColor),
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            }),
      ],
      title: RichText(
        text: TextSpan(
            text: 'Escape',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'VRoom',
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: darkColor.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: StreamBuilder<List<Post>>(
            stream: Provider.of<FirebaseOperation>(context, listen: false)
                .readPosts(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Something went wrong ! ${snapshot.error}",
                  style: TextStyle(color: whiteColor),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final posts = snapshot.data!.toList();

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: ((context, index) {
                    return loadPost(context, posts[index]);
                  }),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context, Post post) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: blueGreyColor.withOpacity(0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (post.userId !=
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AltProfile(
                                userID: post.userId,
                              ),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: blueGreyColor,
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                          post.userImage,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              post.caption,
                              style: TextStyle(
                                color: greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: RichText(
                              text: TextSpan(
                                text: post.userName,
                                style: TextStyle(
                                  color: blueColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        ' ${Provider.of<PostFunctionality>(context, listen: false).showTimeAgo(post.time)}',
                                    style: TextStyle(
                                      color: lightColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(post.caption)
                                .collection('awards')
                                .orderBy('time', descending: true)
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
                                    return Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      height: 30,
                                      width: 30,
                                      child: Image.network(
                                          documentSnapshot['award']),
                                    );
                                  }).toList(),
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.network(
                post.postImage,
                scale: 2,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            Provider.of<PostFunctionality>(context,
                                    listen: false)
                                .showLikes(context, post.caption);
                          },
                          onTap: () {
                            Provider.of<PostFunctionality>(context,
                                    listen: false)
                                .addLike(
                              context,
                              post.caption,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                            );
                          },
                          child: Icon(
                            FontAwesomeIcons.heart,
                            color: redColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(post.caption)
                              .collection('Likes')
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<PostFunctionality>(context,
                                    listen: false)
                                .showCommentSheet(context, post.caption);
                          },
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: blueColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(post.caption)
                              .collection('comments')
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            // Provider.of<PostFunctionality>(context,
                            //         listen: false)
                            //     .showAwardsPresnster(context, post.caption);
                          },
                          onTap: () {
                            Provider.of<PostFunctionality>(context,
                                    listen: false)
                                .showRewards(context, post.caption);
                          },
                          child: Icon(
                            FontAwesomeIcons.award,
                            color: yellowColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(post.caption)
                              .collection('awards')
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Provider.of<Authentication>(context, listen: false)
                              .getUserId ==
                          post.userId
                      ? IconButton(
                          icon: const Icon(EvaIcons.moreVertical),
                          color: whiteColor,
                          onPressed: () {
                            Provider.of<PostFunctionality>(context,
                                    listen: false)
                                .showPostOption(context, post.caption);
                          },
                        )
                      : const SizedBox(width: 0.0, height: 0.0)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
