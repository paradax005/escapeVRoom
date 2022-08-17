import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();

  File? uploadPostImage;
  File get getUploadPostImage => uploadPostImage!;

  late String uploadImageUrl;
  String get getUploadImageUrl => uploadImageUrl;

  final picker = ImagePicker();
  UploadTask? imagePostUploadTask;

  Future pickUploadImagePost(
      BuildContext context, ImageSource imageSource) async {
    final uploadPostImageVal = await picker.pickImage(source: imageSource);
    uploadPostImageVal == null
        ? print('you should select an image to get started ! ')
        : uploadPostImage = File(uploadPostImageVal.path);

    // ignore: use_build_context_synchronously
    uploadPostImage != null ? showUploadedImage(context) : null;
  }

  Future uploadImageToFirebase(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage!.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage!);

    await imagePostUploadTask!.whenComplete(() {
      print('Image post uploaded sucessfully to storage ! ');
    });

    imageReference.getDownloadURL().then((imageUrl) {
      uploadImageUrl = imageUrl;
      print('post image url => $uploadImageUrl');
    });
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.circular(12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: blueColor,
                      onPressed: () {
                        pickUploadImagePost(context, ImageSource.gallery);
                      },
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: blueColor,
                      onPressed: () {
                        pickUploadImagePost(context, ImageSource.camera);
                      },
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  showUploadedImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.transparent,
                //   radius: 60,
                //   backgroundImage: FileImage(uploadPostImage!),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      uploadPostImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        selectPostImageType(context);
                      },
                      child: Text(
                        'Reselect',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: whiteColor,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: blueColor,
                      child: Text(
                        'Confirm Image',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        uploadImageToFirebase(context).whenComplete(() {
                          print('image uploaded to storage sucessfully ! ');
                          editPostSheet(context);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
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
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.image_aspect_ratio,
                              ),
                            ),
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.fit_screen,
                                color: yellowColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Image.file(
                          uploadPostImage!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/images/sunflower.png'),
                      ),
                      Container(
                        height: 100,
                        width: 5,
                        color: blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 120,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: captionController,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(120),
                            ],
                            maxLength: 120,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add a caption',
                              hintStyle: TextStyle(
                                color: whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<FirebaseOperation>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'postimage': getUploadImageUrl,
                      'caption': captionController.text,
                      'username':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getInitUserName,
                      'useremail':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getInitUserEmail,
                      'userimage':
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .getInitUserImage,
                      'userid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserId,
                      'time': Timestamp.now(),
                    }).whenComplete(() async {
                      // Add Data Under userProfile
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserId)
                          .collection('posts')
                          .add({
                        'postimage': getUploadImageUrl,
                        'caption': captionController.text,
                        'username': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getInitUserName,
                        'useremail': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getInitUserEmail,
                        'userimage': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .getInitUserImage,
                        'userid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId,
                        'time': Timestamp.now(),
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  color: blueColor,
                  child: Text(
                    'Share',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
