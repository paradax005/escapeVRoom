import 'dart:async';

import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/landing_screen/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: const LandingScreen(),
                  type: PageTransitionType.bottomToTop,
                  duration: const Duration(milliseconds: 600),
                ),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'Escape',
            style: GoogleFonts.acme(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: whiteColor,
            ),
            children: [
              TextSpan(
                text: 'VRoom',
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: redColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
