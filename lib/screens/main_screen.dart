import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_user_app/constants.dart';
import 'package:uber_user_app/global/global.dart';
import 'package:uber_user_app/screens/mysplash_screen.dart';

import '../constants.dart';
import '../constants.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

            //  For black theme
              newGoogleMapController?.setMapStyle(kSetBlackThemeMap);
            },
          )
        ],
      )
    );
  }
}


// Center(
// child: ElevatedButton(
// child: const Text('Log out'),
// onPressed: () {
// firebaseAuth.signOut();
// Navigator.push(context, MaterialPageRoute(builder: (context)=>
// const MySplashScreen()));
// })
// ),