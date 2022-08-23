import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/authentication.dart';
import '../../../services/firebaseOperation.dart';

class ChatMessageHelper with ChangeNotifier{
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

}