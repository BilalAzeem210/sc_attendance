import 'package:essa_attendence/provider/n_attendence_provider.dart';
import 'package:essa_attendence/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NAttendenceProvider()),
      ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',

        home: SplashScreen(),
            ),
      );
  }
}
