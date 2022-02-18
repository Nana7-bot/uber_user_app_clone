import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_user_app/screens/main_screen.dart';
import 'package:uber_user_app/screens/signup_screen.dart';
import '../constants.dart';
import '../global/global.dart';
import '../widgets/progress_dialogbox.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
     if (!emailTextEditingController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email is invalid');
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: 'Password is required');
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(message: 'Processing, Please wait');
          });

      loginUser();
    }
  }

  loginUser() async {
    final User? firebaseUser = (await firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim())
        .catchError((err) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error' + err.toString());
    }))
        .user;

    if (firebaseUser != null) {

      currentFirebaseUser = firebaseUser;

      Fluttertoast.showToast(msg: "Successful");

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const MainScreen())));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Unable to login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('images/logo.png'),
                ),
                const SizedBox(height: 10),

                const Text('Login', style: TextStyle(color: Colors.grey,
                    fontWeight: FontWeight.bold, fontSize: 26),
                ),

                TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.grey),
                    decoration: kNormalTextInputDecoration.copyWith(labelText: 'Email Address',
                        hintText: 'Email Address')
                ),

                TextField(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: kNormalTextInputDecoration.copyWith(labelText: 'Password',
                        hintText: 'Password')
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreenAccent
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 16,
                        color: Colors.black54)),
                    onPressed: () {
                      validateForm();
                    }),

                TextButton(
                  child: const Text('Don\'t have an account yet. Sign Up Here', style: TextStyle(
                    color: Colors.grey
                  ),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    const SignupScree()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
