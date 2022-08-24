// ignore_for_file: file_names, avoid_print
import 'package:escaperoom/models/post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/screens/landing_screen/landing_utils.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class FirebaseOperation with ChangeNotifier {
  String? initUserName, initUserEmail, initUserImage;

  String? get getInitUserName => initUserName;
  String? get getInitUserEmail => initUserEmail;
  String? get getInitUserImage => initUserImage;

  bool? documentExist;
  bool? get getDocumentExist => documentExist;

  Future uploadUserAvatar(BuildContext context) async {
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);

    await imageUploadTask.whenComplete(() {
      print('Image uploaded sucesfully ! ');
    });

    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();

      print('image url => $url');
      print(
          'useravatar url => ${Provider.of<LandingUtils>(context, listen: false).getUserAvatarUrl}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((doc) {
      initUserName = doc.data()!['username'];
      initUserEmail = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      // print(initUserName);
      // print(initUserEmail);
      // print(initUserImage);
      notifyListeners();
    });
  }

  Future deleteUserData(String uID, dynamic collection) async {
    FirebaseFirestore.instance.collection(collection).doc(uID).delete();
  }

  Future uploadPostData(String postId, dynamic data) async {
    FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Stream<List<Post>> readPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }

  Future addAward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future updateCaptionPost(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocid,
      dynamic followingData,
      String followerUid,
      String followerDocid,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocid)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocid)
          .set(followerData);
    });
  }

  Future<bool> isUserFollowing(String userId, String followingId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('following')
            .doc(followingId)
            .get();
    if (documentSnapshot.exists) {
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  /// Check If Document Exists
  // Future<bool> checkIfDocExists(
  //     String userConnected, String followingId) async {
  //   var collectionRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userConnected)
  //       .collection('following');

  //   var doc = await collectionRef.doc(followingId).get();
  //   return doc.exists;
  // }

  Future submitChatRoomData(
    String chatRoomName,
    dynamic data,
  ) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .set(data);
  }

  Future deleteChatRoom(String chatId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatId)
        .delete();
  }
}
