import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/altProfile/altProfileHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final String userID;
  const AltProfile({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: blueGreyColor.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .headerProfile(context, snapshot, userID),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(context),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .middleProfile(context, snapshot),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .footerProfile(context),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
