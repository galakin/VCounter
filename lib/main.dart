import 'package:flutter/material.dart';
import 'package:vcounter/screen/homepage.dart';
import 'package:vcounter/routeGenerator.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      /*TODO: insert iniatial splash page*/
      home: Homepage(),
      onGenerateRoute: RouteGenerator.generateRoute
    );
  }
}
