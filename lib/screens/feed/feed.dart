import 'package:escaperoom/screens/feed/feed_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkColor.withOpacity(0.6),
        drawer: const Drawer(),
        appBar:
            Provider.of<FeedHelpers>(context, listen: false).appBar(context),
        body: SizedBox(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Provider.of<FeedHelpers>(context, listen: false)
                  .feedBody(context),
            ],
          ),
        )));
  }
}
