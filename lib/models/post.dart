import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String caption;
  String userName;
  String userEmail;
  String userId;
  Timestamp time;
  String postImage;
  String userImage;

  Post({
    required this.caption,
    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.time,
    required this.userImage,
    required this.postImage,
  });

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'postimage': postImage,
        'time': time,
        "useremail": userEmail,
        "userid": userId,
        "userimage": userImage,
        "username": userName
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        caption: json['caption'],
        userEmail: json['useremail'],
        userName: json['username'],
        userId: json['userid'],
        time: json['time'] as Timestamp,
        userImage: json['userimage'],
        postImage: json['postimage'],
      );
}
