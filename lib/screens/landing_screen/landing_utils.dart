// ignore_for_file: use_build_context_synchronously

import 'package:escaperoom/screens/landing_screen/landing_service.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();
  File? userAvatar;
  File get getUserAvatar => userAvatar!;
  late String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource imageSource) async {
    final pickedUserAvatar = await picker.pickImage(source: imageSource);
    pickedUserAvatar == null
        ? print('you should select an image to get started ! ')
        : userAvatar = File(pickedUserAvatar.path);

    userAvatar != null
        ? Provider.of<FirebaseOperation>(context, listen: false)
            .uploadUserAvatar(context)
        : print('error occured when uploading the image ');
  }

  Future selectAvatarOptionSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingServices>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingServices>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
