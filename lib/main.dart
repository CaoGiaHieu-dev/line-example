import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:line_example/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LineSDK.instance.setup('1656654384').then((_) {
    log("LineSDK Prepared");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Theme.of(context).backgroundColor,
              onPressed: () {
                try {
                  LineSDK.instance.login(
                      scopes: ["profile", "openid", "email"]).then((value) {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileWidget(result: value);
                    }), (route) => false);
                  }, onError: (e) {
                    log(e.toString());
                  });
                } on PlatformException catch (e) {
                  log(e.toString());
                }
              },
              child: const Text(
                'Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
