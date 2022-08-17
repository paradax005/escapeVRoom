import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/chatroom/chatroom_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueGreyColor,
        onPressed: () {
          Provider.of<ChatRoomHelper>(context, listen: false)
              .showCreateChatRoomSheet(context);
        },
        child: Icon(
          FontAwesomeIcons.plus,
          color: greenColor,
        ),
      ),
      appBar:
          Provider.of<ChatRoomHelper>(context, listen: false).appBar(context),
      body: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Provider.of<ChatRoomHelper>(context, listen: false)
            .fetchChatRooms(context),
      ),
    );
  }
}
