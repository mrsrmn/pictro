import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scribble/pages/home.dart';
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

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Scribble",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: geologicaRegular
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
