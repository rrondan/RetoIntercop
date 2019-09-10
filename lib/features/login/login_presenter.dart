import 'package:firebase_auth/firebase_auth.dart';

import 'login_contract.dart';

class LoginPresenter {
  LoginContract _view;
  String _verificationCode;

  LoginPresenter(this._view);

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: (AuthCredential authCredential){
          print("verificationCompleted: authCredential: ${authCredential.toString()}");
        },
        verificationFailed: (AuthException exception){
          _view.onError(exception.toString());
        },
        codeSent: (String verId, [int forceCodeResend]) {
          _verificationCode = verId;
          _view.onSendCode();
          print("CodeSend verId: $_verificationCode");
        },
        codeAutoRetrievalTimeout:  (String verId) {
          _verificationCode = verId;
          print("timeOut");
        });
  }

  Future<FirebaseUser> signIn(String smsCode){
    return FirebaseAuth.instance.currentUser().then((user){
      if(user != null){
        _view.onSignInSuccess();
        return user;
      } else {
        final AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: _verificationCode, smsCode: smsCode);
        FirebaseAuth.instance.signInWithCredential(credential).then((user){
          _view.onSignInSuccess();
          return user;
        }).catchError((e)=> _view.onError(e.toString()));
      }
      return null;
    });
  }
}