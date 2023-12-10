  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
import 'package:uas_net/netstation/Login/loginS.dart';
import 'package:uas_net/netstation/Login/registerS.dart';


  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: '1:62159362051:android:d6ac7227843c562a055636',
        apiKey: 'AIzaSyD95OM6v9bbmtA9amlzw83s1lrUed3kBOs',
        messagingSenderId: '62159362051',
        projectId: 'uas-net-l',
      ),
    );


    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: LoginS());
        // home: MainMenu());
    }
  }
