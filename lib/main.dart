import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scribble/pages/main_pages/home_page/home_page.dart';

import 'package:scribble/pages/main_pages/start_page.dart';
import 'package:scribble/utils/auth.dart';
import 'package:scribble/utils/constants.dart';
import 'package:scribble/firebase_options.dart';
import 'package:scribble/injection_container.dart' as sl;

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Injection Container
  await sl.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(Authentication());

  var currentUser = FirebaseAuth.instance.currentUser;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  if (currentUser != null && currentUser.displayName != null) {
    runApp(const MyApp(home: HomePage()));
  } else {
    runApp(const MyApp(home: StartPage()));
  }
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Scribble",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: geologicaRegular,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
        ).apply(
          bodyColor: Colors.white.withOpacity(.9),
          displayColor: Colors.white.withOpacity(.9)
        )
      ),
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
