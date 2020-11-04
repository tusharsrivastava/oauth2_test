import 'package:flutter/material.dart';

import 'infra/classes/auth.dart';
import 'infra/interfaces/iauth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

_startAuth(BuildContext context) async {
  IAuth auth = new OAuth(context);
  await auth.startAuth();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OAuth 2.0 Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Test OAuth 2.0',
            ),
            FlatButton(
              onPressed: () => _startAuth(context),
              child: Text("Authorize"),
            ),
          ],
        ),
      ),
    );
  }
}
