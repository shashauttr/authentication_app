import 'package:auth_simple/landingPage.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'auth_provider.dart';
import 'landingPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authentication demo',
        theme: ThemeData(
          primaryColor: Color(0xFF295578),
        ),
        home: RootPage(),
      ),
    );
  }
}
