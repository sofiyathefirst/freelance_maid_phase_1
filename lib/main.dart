import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/DataHandler/appData.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_pickdatetime.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/pickdatetime2.dart';
import 'package:freelance_maid_phase_1/geolocation/trytrymaps.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Freelance Maid Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
          primarySwatch: Colors.deepPurple,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.lightBlue),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            prefixIconColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        home: SplashScreen2(),
      ),
    );
  }
}
