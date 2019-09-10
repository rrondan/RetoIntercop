import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reto_intercorp/features/create_client/create_client_view.dart';
import 'package:reto_intercorp/features/login/login_view.dart';
import 'package:reto_intercorp/features/splash/splash_view.dart';
import 'package:reto_intercorp/utils/routes.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black.withOpacity(0.2),
      statusBarIconBrightness: Brightness.light
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MaterialApp(
      home: SplashScreen(),
      routes: routes,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en','US'),
        const Locale('es','ES'),
      ],
    ));
  });
}
