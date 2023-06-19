import 'package:flutter/material.dart';

import 'package:scribble/pages/register.dart';
import 'package:scribble/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;

  final LinearGradient gradient = LinearGradient(colors: [
    Colors.purple.shade400,
    Colors.purple.shade700,
  ]);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87
        ),
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: FadeTransition(
            opacity: animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => gradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: const Text(
                      "Scribble",
                      style: TextStyle(
                        fontFamily: geologicaMedium,
                        fontSize: 40,
                      )
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: Text(
                    "Connect with loved ones through art, without leaving your homescreen.",
                    style: TextStyle(fontFamily: geologicaMedium, fontSize: 20, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Register()
                    )
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple.shade500),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    )
                  ),
                  child: const Text(
                    "Get started",
                    style: TextStyle(
                      fontFamily: geologicaMedium,
                      fontSize: 19,
                      color: Colors.white,
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
