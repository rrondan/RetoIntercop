import 'package:flutter/material.dart';
import 'package:reto_intercorp/features/create_client/create_client_view.dart';
import 'package:reto_intercorp/features/login/login_view.dart';
import 'package:reto_intercorp/features/main/main_view.dart';
import 'package:reto_intercorp/features/splash/splash_view.dart';

final routes={
  LoginScreen.routeName: (BuildContext context) => LoginScreen(),
  CreateClientScreen.routeName: (BuildContext context) => CreateClientScreen(),
  MainScreen.routeName: (BuildContext context) => MainScreen(),
  SplashScreen.routeName: (BuildContext context) => SplashScreen(),
};