import 'package:flutter/material.dart';
import 'package:reto_intercorp/ui/overlay_view.dart';
import 'package:reto_intercorp/utils/custom_color.dart';
import 'package:reto_intercorp/utils/custom_string.dart';
import 'package:reto_intercorp/utils/custom_styles.dart';

class DialogLoading with CustomStyles{

  final BuildContext context;
  bool _dialogOpen = false;
  final bool dismisible;

  DialogLoading({this.context,this.dismisible = false});

  void show(){
    if(!_dialogOpen) {
      Navigator.push(context, OverlayView(
          dismissible: dismisible,
          content: Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 60.0,
                      width: 60.0,
                      child: CircularProgressIndicator()),
                  SizedBox(height: 20.0,),
                  Text(CustomString.loading, style: titleTextStyle.merge(TextStyle(color: CustomColor.textColorNegative)),)
                ],
              ),
            ),
          )
      ));
    }
    _dialogOpen = true;
  }

  Future hide({int seconds}){
    if(_dialogOpen) {
      _dialogOpen = false;
      return new Future.delayed(Duration(seconds: seconds == null ? 2 : seconds), () => Navigator.pop(context));
    }
  }
}