// ignore_for_file: slash_for_doc_comments
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/home/home.dart';
import 'package:escaperoom/screens/landing_screen/landing_utils.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingServices with ChangeNotifier {
  /**
   * Controllers 
   */
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();

  final List historyUsers = [];

  /**
   * Methods 
   */

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: blueGreyColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context, listen: false)
                        .userAvatar!,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery);
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
                        onPressed: () {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .uploadUserAvatar(context)
                              .whenComplete(() {
                            Navigator.pop(context);
                            signInSheet(context);
                          });
                        },
                        child: Text(
                          'Confirm Image',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailLoginController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      hintText: "enter your email",
                      hintStyle: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: TextField(
                    controller: passwordLoginController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      hintText: "enter your Password",
                      hintStyle: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: FloatingActionButton(
                    elevation: 8,
                    onPressed: () {
                      if (emailLoginController.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .logIntoAccount(emailLoginController.text,
                                passwordLoginController.text)
                            .whenComplete(
                          () {
                            emailLoginController.clear();
                            passwordLoginController.clear();
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .initUserData(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false,
                            );

                            // Navigator.pushReplacement(
                            //   context,
                            //   PageTransition(
                            //     child: const HomeScreen(),
                            //     type: PageTransitionType.fade,
                            //     duration: const Duration(seconds: 2),
                            //   ),
                            // );
                          },
                        );
                      } else {
                        warningText(context, "Fill all the data");
                      }
                    },
                    backgroundColor: blueColor,
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future signInSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: blueGreyColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
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
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: CircleAvatar(
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context, listen: false)
                        .getUserAvatar,
                  ),
                  radius: 60,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: "enter your username",
                    hintStyle: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: "enter your email",
                    hintStyle: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: "enter your password",
                    hintStyle: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: FloatingActionButton(
                  elevation: 8,
                  onPressed: () {
                    if (emailController.text.isNotEmpty) {
                      Provider.of<Authentication>(context, listen: false)
                          .createAccount(
                              emailController.text, passwordController.text)
                          .whenComplete(() {
                        print('waiting to add a new document ! ');
                        try {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .createUserCollection(context, {
                            'userId': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserId,
                            'useremail': emailController.text,
                            'username': usernameController.text,
                            'userpassword': passwordController.text,
                            'userimage': Provider.of<LandingUtils>(context,
                                    listen: false)
                                .getUserAvatarUrl
                          }).whenComplete(() {
                            print('Document created sucessfully ! ');
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: const HomeScreen(),
                                type: PageTransitionType.fade,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          });
                        } catch (e) {
                          print('an error was occured ${e.toString()}');
                        }
                      });
                    } else {
                      warningText(context, "Fill all the data");
                    }
                  },
                  backgroundColor: redColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  warningText(BuildContext context, String message) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                message,
                style: TextStyle(color: whiteColor),
              ),
            ),
          );
        });
  }

  /**
   * Widgets 
   */

/*
  Widget passwordHistorySignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        
          else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No Data set',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                ),
              ),
            );
          }
          else {
            
            return ListView(
              children:
              
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                  //   Map<String, dynamic> data =
                  // documentSnapshot.data() as Map<String, dynamic>;
                return ListTile(
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.trashCan,
                      color: redColor,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      documentSnapshot.get('userimage') ?? null,
                    ),
                  ),
                  title: Text(
                    documentSnapshot.get('username') ??'',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: greenColor),
                  ),
                  subtitle: Text(
                    documentSnapshot.get('useremail') ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: greenColor),
                  ),
                );
              }).toList(),
            );
          }
        }
        ),
      ),
    );
  }*/
}
