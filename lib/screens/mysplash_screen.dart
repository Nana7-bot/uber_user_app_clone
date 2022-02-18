import 'dart:async';

import 'package:flutter/material.dart';

import '../global/global.dart';
import 'login_screen.dart';
import 'main_screen.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  setTimer() {
    Timer(const Duration(seconds: 3), () async{

    if(firebaseAuth.currentUser != null) {
    Navigator.push(context, MaterialPageRoute(
            builder: (context)=> const MainScreen()
        ));
    }
    else {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> const LoginScreen()
        ));
        } 
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png'),
            const SizedBox(height: 10),
            const Text('Uber Clone App', style: TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
