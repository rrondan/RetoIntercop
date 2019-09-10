import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'create_client_contract.dart';

class CreateClientPresenter{
  CreateClientContract _view;

  CreateClientPresenter(this._view);

  void createClient(String name, String lastName, String age, String birthDate, String latitude, String longitude) async{
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("clients")
        .document(currentUser.uid)
        .setData({
          "name" : name,
          "lastName" : lastName,
          "age" : age,
          "birthDate" : birthDate,
          "latitude" : latitude,
          "longitude" : longitude,
        }).then((val){
          print("ON SUCCESS: VAL: ");
          _view.onSuccess();
        }, onError: (error){
            _view.onError(error.toString());
        }).catchError((error){
          _view.onError(error.toString());
        });
  }

}