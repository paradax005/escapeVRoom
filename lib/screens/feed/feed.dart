import 'package:escaperoom/screens/feed/feedHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkColor.withOpacity(0.6),
        
        drawer: Drawer(),
        appBar:
            Provider.of<FeedHelpers>(context, listen: false).appBar(context),
        body: Container(
            // const EdgeInsets.only(bottom: kBottomNavigationBarHeight - 10),
            child: SingleChildScrollView(
          child: Column(
            children: [
              Provider.of<FeedHelpers>(context, listen: false)
                  .feedBody(context),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )));
  }
}
