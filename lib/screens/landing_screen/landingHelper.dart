import 'package:escaperoom/screens/home/home.dart';
import 'package:escaperoom/screens/landing_screen/landing_service.dart';
import 'package:escaperoom/screens/landing_screen/landing_utils.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class LandingHelpers with ChangeNotifier {
  // Top Image Landing Screen
  Widget bodyImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/getstarted.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget welcomeWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 60),
      constraints: const BoxConstraints(
        maxWidth: 220,
      ),
      child: RichText(
        text: TextSpan(
          text: 'Welcome to ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
          children: [
            TextSpan(
              text: 'Escape',
              style: TextStyle(
                fontSize: 28,
                color: whiteColor,
              ),
            ),
            TextSpan(
              text: 'VRoom\'s ',
              style: TextStyle(
                fontSize: 28,
                color: redColor,
              ),
            ),
            TextSpan(
              text: 'Community',
              style: TextStyle(
                fontSize: 22,
                color: lightBlueColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mainButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              customButtomSheet(context);
            },
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: yellowColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                EvaIcons.emailOutline,
                color: yellowColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<Authentication>(context, listen: false)
                  .signInWithGoogle()
                  .whenComplete(
                    () => Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const HomeScreen(),
                          type: PageTransitionType.leftToRight),
                    ),
                  );
            },
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: redColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                EvaIcons.google,
                color: redColor,
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: blueColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                EvaIcons.facebook,
                color: blueColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "By Continuining you agree escapeRoom's Terms of ",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            Text(
              "Services & Privacy Policy ",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  customButtomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
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
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Provider.of<LandingServices>(context, listen: false)
                          .passwordHistorySignIn(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: blueColor,
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<LandingServices>(context,
                                      listen: false)
                                  .loginSheet(context);
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                          MaterialButton(
                            color: redColor,
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<LandingUtils>(context,
                                      listen: false)
                                  .selectAvatarOptionSheet(context);
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
