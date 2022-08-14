import 'package:flutter/material.dart';
import 'package:vcounter/screen/homepage.dart';
import 'package:vcounter/routeGenerator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vcounter/state/state.dart';
import 'package:vcounter/reducers/reducer.dart';
import 'package:vcounter/actions/action.dart';
import 'package:vcounter/middlewares/middleware.dart';
import 'package:vcounter/futures/tournamentFuture.dart';
import 'package:vcounter/resources/circularIndicator.dart';
import 'package:vcounter/screen/testPage.dart';
import 'package:vcounter/screen/newGame/newGame.dart';
import 'package:vcounter/futures/startingFuture.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _initialState = new AppState();
  final Store _store = new Store<AppState>(
    reducer,
    initialState: _initialState,
    middleware: [standardMiddleware],
  );

  runApp(MyApp(_store));
}

class MyApp extends StatefulWidget {
  Store _store;
  MyApp(this._store);
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  State createState() => MyAppState(_store);
}

class MyAppState extends State{
  Future _taintedGame;
  Store _store;

  MyAppState(this._store);

  initState(){
    super.initState();
    _taintedGame = sartFuture(_store);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FutureBuilder(
      future: _taintedGame,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (!snapshot.hasData) return BackgroundCircularIndicator();
        else  {
          print("");
          StatefulWidget _homepage = Homepage(_store);
          if (snapshot.data.length == 1) {
            var _taintGame = {};
            snapshot.data[0].forEach((key, value) => _taintGame[key] = value);
            _homepage = NewGame(
              _store,
              0,
              2,
              [],
              [_taintGame["life1"], _taintGame["life2"], _taintGame["life3"], _taintGame["life4"]],
              [_taintGame["poison1"], _taintGame["poison2"], _taintGame["poison3"], _taintGame["poison4"]],
              [_taintGame["commander1"], _taintGame["commander2"], _taintGame["commander3"], _taintGame["commander4"]]);
          }
          else if (snapshot.data.length > 1)throw Exception("Tainted game list have an unusual length of ${snapshot.data.length} elements");
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            /*TODO: insert iniatial splash page*/
            home: _homepage,
            onGenerateRoute: RouteGenerator.generateRoute
          );

        }
      }
    );
  }
}
