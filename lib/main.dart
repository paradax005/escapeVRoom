import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/screens/landing_screen/landingHelper.dart';
import 'package:escaperoom/screens/splash_screen/splash_screen.dart';
import 'package:escaperoom/services/authentication.dart';
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
        ChangeNotifierProvider(
          create: (_) => LandingHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => Authentication(),
        ),
      ],
    );
  }
}
