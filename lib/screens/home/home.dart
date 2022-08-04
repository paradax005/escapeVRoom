import 'package:escaperoom/constants/appcolors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
