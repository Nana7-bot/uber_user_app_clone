import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_user_app/screens/main_screen.dart';
import 'package:uber_user_app/screens/mysplash_screen.dart';
import '../constants.dart';
import '../global/global.dart';
import '../widgets/progress_dialogbox.dart';
import 'login_screen.dart';
// import 'package:uber_clone_driver/widgets/progress_dialogbox.dart';

class SignupScree extends StatefulWidget {
  const SignupScree({Key? key}) : super(key: key);

  @override
  _SignupScreeState createState() => _SignupScreeState();
}

class _SignupScreeState extends State<SignupScree> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: 'Name should be at lest 3 characters');
    } else if (!emailTextEditingController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email is invalid');
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone number is required');
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: 'Password should be more than 6 characters');
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(message: 'Processing, Please wait');
          });

      saveDriverInfo();
    }
  }

  saveDriverInfo() async {
    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((err) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error' + err.toString());
      print(err);
    }))
        .user;

    if (firebaseUser != null) {
      // ignore: unused_local_variable
      Map usersMap = {
        'id': firebaseUser.uid,
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'phone': phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child('users');
      driversRef.child(firebaseUser.uid).set(usersMap);

      currentFirebaseUser = firebaseUser;

      Fluttertoast.showToast(msg: "Account created successfully");

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const MySplashScreen())));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Account unable to be created');
    }
  }

  Widget buildToast() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.greenAccent, borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.check,
              color: Colors.black26,
            ),
            SizedBox(width: 12.0),
            Text(
              'This is a Custom Toaster',
              style: TextStyle(fontSize: 20, color: Colors.black),
            )
          ],
        ),
      );

  final toast = FToast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    toast.init(context);
  }

  // toast.showToast(child: buildToast(),
  // gravity: ToastGravity.BOTTOM);

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
                  padding: const EdgeInsets.all(25.0),
                  child: Image.asset('images/logo.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Register As a User',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                TextField(
                    controller: nameTextEditingController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: kNormalTextInputDecoration.copyWith(
                        labelText: 'Name', hintText: 'Name')),
                TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.grey),
                    decoration: kNormalTextInputDecoration.copyWith(
                        labelText: 'Email Address', hintText: 'Email Address')),
                TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.grey),
                    decoration: kNormalTextInputDecoration.copyWith(
                        labelText: 'Phone Number', hintText: 'Phone Number')),
                TextField(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: kNormalTextInputDecoration.copyWith(
                        labelText: 'Password', hintText: 'Password')),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreenAccent),
                    child: const Text('Create Account',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                    onPressed: () {
                      validateForm();
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) => const CarInfoScreen()));
                    }),
                TextButton(
                  child: const Text(
                    'Already have an account. Login Here',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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
