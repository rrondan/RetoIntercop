import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reto_intercorp/features/create_client/create_client_view.dart';
import 'package:reto_intercorp/features/login/login_view.dart';
import 'package:reto_intercorp/features/main/main_view.dart';
import 'package:reto_intercorp/utils/custom_color.dart';
import 'package:reto_intercorp/utils/custom_image.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/Splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async{
      var currentUser = await FirebaseAuth.instance.currentUser();
      if(currentUser == null){
        Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName,
                (Route<dynamic> route) => false);
      } else {
        Firestore.instance.collection("clients").document(currentUser.uid)
            .get()
            .then((docSnap){
              if(docSnap.exists){
                Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName,
                        (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(CreateClientScreen.routeName,
                        (Route<dynamic> route) => false);
              }
        }, onError: (error){
          print("ERROR FIRESTORE: $error");
          Navigator.of(context).pushNamedAndRemoveUntil(CreateClientScreen.routeName,
                  (Route<dynamic> route) => false);
        }).catchError((error){
          print("ERROR FIRESTORE: $error");
          Navigator.of(context).pushNamedAndRemoveUntil(CreateClientScreen.routeName,
                  (Route<dynamic> route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundSecondary,
      body: Center(
        child: Image.asset(CustomImage.LOGO_FLUTTER),
      ),
    );
  }

}
