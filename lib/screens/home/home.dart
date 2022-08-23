import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/chatroom/chatroom.dart';
import 'package:escaperoom/screens/feed/feed.dart';
import 'package:escaperoom/screens/home/homePageHelper.dart';
import 'package:escaperoom/screens/profile/profile_screen.dart';
import 'package:escaperoom/screens/search/search_user.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
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
  void initState() {
    Provider.of<FirebaseOperation>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

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
        children: const [FeedScreen(), ChatRoomScreen(), SearchUser(),ProfileScreen()],
      ),
      bottomNavigationBar: Provider.of<HomePageHelper>(context, listen: false)
          .bottomNavBar(context,pageIndex, homePageController),
    );
  }
}
