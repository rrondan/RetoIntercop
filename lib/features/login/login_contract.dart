abstract class LoginContract{
  void onSendCode();
  void onSignInSuccess();
  void onError(String error);
}