import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reto_intercorp/features/splash/splash_view.dart';
import 'package:reto_intercorp/utils/custom_color.dart';
import 'package:reto_intercorp/utils/custom_string.dart';
import 'package:reto_intercorp/utils/custom_styles.dart';
import 'package:reto_intercorp/utils/general_utils.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/Main";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with CustomStyles {

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
  }

  void _setCurrentUser() async{
    _currentUser = await FirebaseAuth.instance.currentUser();
    if(_currentUser == null){
      GeneralUtils.showToast(msg:"Su sessión caduco");
      Navigator.of(context).pushNamedAndRemoveUntil(SplashScreen.routeName,
              (Route<dynamic> route) => false);
    }
    setState(() {

    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundPrincipal,
      appBar: AppBar(
        title: Text(CustomString.welcome,
            style: headerTextStyle
                .merge(TextStyle(color: CustomColor.textColorNegative))),
        backgroundColor: CustomColor.primaryColor,
      ),
      body: SafeArea(
        child: _currentUser == null ? Center(child: CircularProgressIndicator()) : _body(),
      ),
    );
  }

  Widget _body(){
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('clients').document(_currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Bienvenido ${snapshot.data['name']} ${snapshot.data['lastName']}",
                textAlign: TextAlign.center,
                style: titleTextStyle,
              ),
              SizedBox(height: 32),
              OutlineButton(
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
                borderSide: BorderSide(color: CustomColor.primaryColor),
                highlightedBorderColor: CustomColor.primaryColor,
                hoverColor: CustomColor.primaryColor,
                textColor: CustomColor.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: Text(CustomString.logout,
                    style: buttonTextStyle.merge(TextStyle(color: CustomColor.primaryColor))
                ),
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(SplashScreen.routeName,
                          (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        }
      ),
    );
  }


}
