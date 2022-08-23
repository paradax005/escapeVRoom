import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/altProfile/alt_profile_helper.dart';
import 'package:escaperoom/screens/chatroom/chatroom_helper.dart';
import 'package:escaperoom/screens/feed/feed_helper.dart';
import 'package:escaperoom/screens/home/homePageHelper.dart';
import 'package:escaperoom/screens/landing_screen/landingHelper.dart';
import 'package:escaperoom/screens/landing_screen/landing_service.dart';
import 'package:escaperoom/screens/landing_screen/landing_utils.dart';
import 'package:escaperoom/screens/messaging/direct_messaging/chat_message_helper.dart';
import 'package:escaperoom/screens/messaging/group_messaging/group_message_helper.dart';
import 'package:escaperoom/screens/profile/profile_helper.dart';
import 'package:escaperoom/screens/splash_screen/splash_screen.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:escaperoom/utils/post_functionality.dart';
import 'package:escaperoom/utils/upload_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: sort_child_properties_last
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Escape VRoom',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: blueColor, // Your accent color
          ),
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
        ),
        home: const SplashScreen(),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => ChatMessageHelper()),
        ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
        ChangeNotifierProvider(create: (_) => ChatRoomHelper()),
        ChangeNotifierProvider(create: (_) => AltProfileHelper()),
        ChangeNotifierProvider(create: (_) => PostFunctionality()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => ProfileHelper()),
        ChangeNotifierProvider(create: (_) => HomePageHelper()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingServices()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperation()),
      ],
    );
  }
}
