import 'dart:async';

import 'package:flutter/material.dart';

class OverlayView extends ModalRoute<Map<String,bool>> {

  Widget content;
  int durationClose;
  bool animationStarted = false;
  Timer timer;
  Color color;
  bool dismissible = true;

  OverlayView({this.content,this.durationClose = 0,this.color = Colors.black, this.dismissible = true});

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => dismissible;

  @override
  Color get barrierColor => color.withOpacity(0.75);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    return WillPopScope(
      onWillPop: () => Future.value(barrierDismissible),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: _buildOverlayContent(context),
            onTap: () => dismissible ? Navigator.of(context).pop() : null,
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    if(timer != null)
      timer.cancel();
    super.dispose();
  }

  startTime(BuildContext context) async {
    var _duration = new Duration(seconds: 5);
    timer = new Timer(_duration, () =>Navigator.pop(context));
    return timer;
  }


  Widget _buildOverlayContent(BuildContext context) {
/*    if(durationClose != 0){
      animationStarted = true;
      startTime(context);
    }*/
    return content == null ? Container(child: CircularProgressIndicator(),width: 50.0,height: 50.0,) : content;
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
