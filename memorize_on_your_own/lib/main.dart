
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:memorize_on_your_own/listTopic.dart';

import 'package:memorize_on_your_own/testPage.dart';
import 'logins/loginPage.dart';
import 'logins/signIn.dart';

import 'testAndTest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('tr')],
      title: 'Memorize',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/LoginPage': (context) => LoginPage(),
        '/SignInPage': (context) => SignInPage(),
        '/TestPage':(context)=>TestPage(),
        '/Testandtest': (context)=>ExampleForm(),
        '/testpage':(context)=>TestPage(),
        '/listtopic':(context)=>ListTopic(),
      },
      initialRoute: '/LoginPage',
      onUnknownRoute: (RouteSettings routeSetting) =>
          MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
