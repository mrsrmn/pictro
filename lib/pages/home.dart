import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.deepPurple,
              Colors.purpleAccent,
            ],
          )
        ),
        child: const SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Icon(Icons.brush_rounded, size: 100, color: Colors.black87),
              )
            ],
          ),
        ),
      ),
    );
  }
}
