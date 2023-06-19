import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scribble/pages/home.dart';
import 'package:scribble/utils/constants.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness:Brightness.dark ,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
