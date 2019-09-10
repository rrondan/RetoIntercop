import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reto_intercorp/features/create_client/create_client_view.dart';
import 'package:reto_intercorp/features/login/login_contract.dart';
import 'package:reto_intercorp/features/login/login_presenter.dart';
import 'package:reto_intercorp/ui/custom_text_form_field.dart';
import 'package:reto_intercorp/utils/custom_color.dart';
import 'package:reto_intercorp/utils/custom_image.dart';
import 'package:reto_intercorp/utils/custom_string.dart';
import 'package:reto_intercorp/utils/custom_styles.dart';
import 'package:reto_intercorp/utils/general_utils.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with CustomStyles implements LoginContract{

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formSMSKey = new GlobalKey<FormState>();
  String _phoneNumber;
  String _smsCode;
  LoginPresenter _presenter;
  bool _loadingForm, _loadingCode;
  bool _dialogOpen = false;


  @override
  void initState() {
    super.initState();
    _loadingForm = _loadingCode = false;
    _presenter = new LoginPresenter(this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 32),
                      alignment: Alignment.center,
                      child: Image.asset(CustomImage.LOGO_FLUTTER, height: 180.0)
                  ),
                  Text(CustomString.titleApp,
                    textAlign: TextAlign.center,
                    style: headerTextStyle.merge(TextStyle(color: CustomColor.textColorSecondary)),
                  ),
                  SizedBox(height: 40.0,),
                  _textFieldCellphone(),
                  SizedBox(height: 32.0,),
                  _loadingForm ? Center(child: CircularProgressIndicator()):_buttonSendCode(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldCellphone(){
    return CustomTextFormField(
      labelText: CustomString.labelCellphone,
      hint: CustomString.hintEnterCellphone,
      validator: _validateCellphone,
      onSaved: (String val) => _phoneNumber = val,
      keyboardType: TextInputType.phone,
    );
  }
  Widget _buttonSendCode(){
    return FlatButton(
        onPressed: _summit,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: CustomColor.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 22.0),
        child: Text(CustomString.sendCode.toUpperCase(),
            style: buttonTextStyle.merge(TextStyle(color: CustomColor.textColorNegative))));
  }

  String _validateCellphone(String value){
    String cellPhone = value.trim();
    if(cellPhone.length < 9){
      return CustomString.enterCorrectCellphone9Digits;
    } else if(cellPhone[0] != "+"){
      return CustomString.enterCorrectCellphoneCountryCode;
    }
    return null;
  }

  String _validateCode(String code){
    String codeValidate = code.trim();
    if(codeValidate.length < 6){
      return CustomString.enterValidCode;
    }
    return null;
  }

  _summit(){
    print("_summit");
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      setState(() {
        _loadingForm = true;
      });
      _presenter.verifyPhoneNumber(_phoneNumber);
    }
  }

  @override
  void onError(String error) {
    setState(() {
      _loadingCode = _loadingForm = false;
    });
    GeneralUtils.showToast(msg: error);
  }

  @override
  void onSendCode() {
    setState(() {
      _loadingForm = false;
    });
    if(!_dialogOpen) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Form(
              key: _formSMSKey,
              child: AlertDialog(
                title: Text(CustomString.enterCode),
                content: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 24),
                  child: TextFormField(
                    style: titleTextStyle,
                    validator: _validateCode,
                    onSaved: (value) => _smsCode = value,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        hintText: CustomString.enterCode,
                        counter: new SizedBox(height: 0.0),
                        contentPadding: const EdgeInsets.only(
                            top: 0.0, bottom: 5.0),
                        hintStyle: titleTextStyle.merge(
                            TextStyle(color: CustomColor.textColorDisabled))
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.all(10.0),
                actions: <Widget>[
                  _loadingForm ? Center(child: CircularProgressIndicator()) :
                  _loadingCode ? null :
                  FlatButton(
                    child: Text(CustomString.resendCode),
                    onPressed: () => setState((){
                      _loadingForm = true;
                      _presenter.verifyPhoneNumber(_phoneNumber);
                    })
                  ),
                  _loadingCode ? Center(child: CircularProgressIndicator()) :
                  FlatButton(
                    child: Text(CustomString.verify),
                    onPressed: () {
                      if (_formSMSKey.currentState.validate()) {
                        _formSMSKey.currentState.save();
                        setState(() {
                          _loadingCode = true;
                        });
                        _presenter.signIn(_smsCode);
                      }
                    },
                  )
                ].where((child) => child != null).toList(),
              ),
            );
          }
      );
      _dialogOpen = true;
    }
  }

  @override
  void onSignInSuccess() {
    setState(() {
      _dialogOpen = _loadingCode = _loadingForm = false;
    });
    Navigator.pop(context);

    _goToCreateClient();
  }

  _goToCreateClient(){
    Navigator.of(context).pushNamedAndRemoveUntil(CreateClientScreen.routeName,
            (Route<dynamic> route) => false);
  }
}
