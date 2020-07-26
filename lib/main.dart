import 'package:flutter/material.dart';
import 'package:vcounter/screen/homepage.dart';
import 'package:vcounter/routeGenerator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:vcounter/state/state.dart';
import 'package:vcounter/reducers/reducer.dart';
import 'package:vcounter/actions/action.dart';
import 'package:vcounter/middlewares/middleware.dart';

void main() {
  final _initialState = new AppState();
  final Store _store = new Store<AppState>(
    reducer,
    initialState: _initialState,
    middleware: [standardMiddleware],
  );

  runApp(MyApp(_store));
}

class MyApp extends StatelessWidget {
  Store _store;

  MyApp(this._store);

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
      home: Homepage(_store),
      onGenerateRoute: RouteGenerator.generateRoute
    );
  }
}
