import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/chatroom/chatroom.dart';
import 'package:escaperoom/screens/feed/feed.dart';
import 'package:escaperoom/screens/home/homePageHelper.dart';
import 'package:escaperoom/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController homePageController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: PageView(
        controller: homePageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
        children: const [FeedScreen(), ChatRoomScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: Provider.of<HomePageHelper>(context,listen: false)
          .bottomNavBar(pageIndex, homePageController),
    );
  }
}
