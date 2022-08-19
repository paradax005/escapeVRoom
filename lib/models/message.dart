import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String sticker;
  String userName;
  String userEmail;
  String userUid;
  Timestamp time;

  Message({
    required this.message,
    required this.sticker,
    required this.userName,
    required this.userEmail,
    required this.userUid,
    required this.time,
  });

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      sticker: json['sticker'],
      userName: json['username'],
      userEmail: json['useremail'],
      userUid: json['useruid'],
      time: json['time'] as Timestamp,
    );
  }
}
