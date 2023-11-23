import 'dart:async';
import 'package:essa_attendence/screens/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:essa_attendence/screens/profile_screen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4),
            (){
          Navigator.pushReplacement(context,PageTransition( type: PageTransitionType.rightToLeft, child: const LoginView(),
              duration: const Duration(seconds: 3)
          ));
        });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: const AssetImage('assets/images/sclogo.png'),
            height: MediaQuery.of(context).size.height * 0.3,
         ),
          ],
        ),
    ),
    );
  }
}
