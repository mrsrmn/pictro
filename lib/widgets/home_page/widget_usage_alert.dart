import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:scribble/utils/utils.dart';

class WidgetUsageAlert extends StatefulWidget {
  const WidgetUsageAlert({super.key});

  @override
  State<WidgetUsageAlert> createState() => _WidgetUsageAlertState();
}

class _WidgetUsageAlertState extends State<WidgetUsageAlert> {
  late Future<bool> future;
  bool visible = true;

  Future<bool> checkWidgetStatus() async {
    try {
      return await Utils.getWidgetStatus();
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  void initState() {
    future = checkWidgetStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }

          bool result = snapshot.data!;

          if (result == false) {
            return Card(
              color: const Color(0xff3d3d3d),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                visible = false;
                              });
                            },
                            icon: Icon(Icons.cancel, color: Colors.white.withOpacity(.9))
                          ),
                        ),
                        const AutoSizeText("Use our widget in your homescreen!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: AutoSizeText(
                        "By adding the widget, you can fully experience everything that Scribble has to offer.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12
                        )
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}