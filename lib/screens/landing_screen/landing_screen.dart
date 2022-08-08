import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/landing_screen/landingHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          backgroundColor(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Provider.of<LandingHelpers>(context, listen: false)
                  .bodyImage(context),
              Provider.of<LandingHelpers>(context, listen: false)
                  .welcomeWidget(context),
              Provider.of<LandingHelpers>(context, listen: false)
                  .mainButtons(context),
              Provider.of<LandingHelpers>(context, listen: false)
                  .privacyText(context),
            ],
          )
        ],
      ),
    );
  }
}

Widget backgroundColor() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.5, 0.9],
        colors: [
          darkColor,
          blueGreyColor,
        ],
      ),
    ),
  );
}
