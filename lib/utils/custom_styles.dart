import 'package:flutter/material.dart';

import 'custom_color.dart';

class CustomStyles{

  /// Regular FontWeight.w400
  /// SemiBold FontWeight.w600
  /// Bold FontWeight.w700

  TextStyle headerTextStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: CustomColor.textColorPrincipal,
    letterSpacing: -0.32
  );

  TextStyle titleTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: CustomColor.textColorPrincipal,
    letterSpacing: -0.32
  );

  TextStyle subtitleOneTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: CustomColor.textColorPrincipal,
    letterSpacing: -0.32
  );

  TextStyle subtitleTwoTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    color: CustomColor.textColorPrincipal,
  );


  TextStyle paragraphTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: CustomColor.textColorPrincipal,
  );

  TextStyle captionTextStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: CustomColor.textColorPrincipal,
  );

  TextStyle buttonTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: CustomColor.textColorPrincipal,
  );

}