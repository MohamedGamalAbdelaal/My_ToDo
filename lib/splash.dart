import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Home(),
      title: Text(
        'ToDo App',
        style: TextStyle(
            fontFamily: "ahmed",
            fontSize: 80,
            fontWeight: FontWeight.w900,
            color: Colors.green),
      ),
      imageBackground: AssetImage('assets/images/1.jpg'),
      styleTextUnderTheLoader: new TextStyle(),
      useLoader: false,
    );
  }
}
