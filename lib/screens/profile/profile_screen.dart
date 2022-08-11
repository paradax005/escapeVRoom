import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/screens/profile/profile_helper.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(
          EvaIcons.settings2Outline,
          color: lightBlueColor,
        ),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.logOutOutline,
              color: lightBlueColor,
            ),
            onPressed: () {
              Provider.of<ProfileHelper>(context, listen: false)
                  .logOutDialog(context);
            },
          ),
        ],
        backgroundColor: blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: 'My',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ), // TextStyle
              children: <TextSpan>[
                TextSpan(
                  text: 'Profile',
                  style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ), // TextStyle
                ) // TextSpan
              ]), //<TextSpan>[]// TextSpan
        ), // RichText
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: blueGreyColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Provider.of<ProfileHelper>(context, listen: false)
                          .headerProfile(context, snapshot),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .divider(context),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .middleProfile(context, snapshot),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .footerProfile(context),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
