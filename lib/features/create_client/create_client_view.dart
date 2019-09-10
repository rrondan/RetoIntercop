import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:reto_intercorp/dialogs/dialog_loading.dart';
import 'package:reto_intercorp/features/create_client/create_client_contract.dart';
import 'package:reto_intercorp/features/create_client/create_client_presenter.dart';
import 'package:reto_intercorp/features/main/main_view.dart';
import 'package:reto_intercorp/ui/custom_text_form_field.dart';
import 'package:reto_intercorp/utils/custom_color.dart';
import 'package:reto_intercorp/utils/custom_string.dart';
import 'package:reto_intercorp/utils/custom_styles.dart';
import 'package:reto_intercorp/utils/general_utils.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class CreateClientScreen extends StatefulWidget {
  static const routeName = "/CreateClient";
  @override
  _CreateClientScreenState createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> with CustomStyles implements CreateClientContract{

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _controllerLatitude = new TextEditingController();
  TextEditingController _controllerLongitude = new TextEditingController();
  CreateClientPresenter _presenter;

  String _name, _lastName, _age, _birthDate, _lat, _lng;

  FocusNode _focusNodeLastName = new FocusNode();
  FocusNode _focusNodeAge = new FocusNode();
  FocusNode _focusNodeLng = new FocusNode();
  DialogLoading _loading;

  @override
  void initState() {
    super.initState();
    _presenter = new CreateClientPresenter(this);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading == null)
      _loading = DialogLoading(context: context, dismisible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundPrincipal,
      appBar: AppBar(
        title: Text(CustomString.createClientTitle,
            style: headerTextStyle
                .merge(TextStyle(color: CustomColor.textColorNegative))),
        backgroundColor: CustomColor.primaryColor,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check, color: Colors.white), onPressed: (){
            if(_formKey.currentState.validate() && _birthDate.isNotEmpty){
              _formKey.currentState.save();
              _loading.show();
              _presenter.createClient(_name, _lastName, _age, _birthDate, _lat, _lng);
            }
          })
        ],
      ),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CustomTextFormField(
                labelText: CustomString.nameTitle,
                hint: CustomString.nameHint,
                validator: _validateEmpty,
                onSaved: (text)=>_name = text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_focusNodeLastName),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                focusNode: _focusNodeLastName,
                labelText: CustomString.lastNameTitle,
                hint: CustomString.lastNameHint,
                validator: _validateEmpty,
                onSaved: (text)=>_lastName = text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_focusNodeAge),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                focusNode: _focusNodeAge,
                labelText: CustomString.ageTitle,
                hint: CustomString.ageHint,
                validator: _validateEmpty,
                maxLength: 2,
                onSaved: (text)=> _age = text,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 16),
              _birthDateField(),
              SizedBox(height: 16),
              _locationOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _birthDateField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(CustomString.birthDateTitle,
            style: paragraphTextStyle.merge(TextStyle(color: CustomColor.primaryDarkColor))),
        DateTimeField(
          format: DateFormat('dd/MM/yyyy'),
          decoration:  InputDecoration(
            hintText: CustomString.birthDateHint,
            contentPadding: const EdgeInsets.only(top: 0.0, bottom: 5.0),
            hintStyle: titleTextStyle.merge(TextStyle(color: CustomColor.textColorDisabled))
          ),
          onChanged: (text){
            _birthDate = DateFormat('dd/MM/yyyy').format(text);
          },
          readOnly: true,
          resetIcon: null,
          onShowPicker: (context, currentValue){
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                locale: Locale('es'),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime.now());
          },
        ),
      ],
    );
  }

  Widget _locationOptions(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: CustomTextFormField(
            controller: _controllerLatitude,
            labelText: CustomString.latitude,
            hint: CustomString.latitude,
            validator: _validateEmpty,
            onSaved: (text)=>_lat = text,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_focusNodeLng),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: CustomTextFormField(
            focusNode: _focusNodeLng,
            controller: _controllerLongitude,
            labelText: CustomString.longitude,
            hint: CustomString.longitude,
            validator: _validateEmpty,
            onSaved: (text)=>_lng = text,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 8.0),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CustomColor.primaryColor,
          ),
          child: IconButton(
            icon: Icon(Icons.my_location, color: CustomColor.textColorNegative),
            onPressed: _getCurrentLocation,
          ),
        )
      ],
    );
  }

  String _validateEmpty(String value){
    if(value.trim().isEmpty){
      return CustomString.requiredField;
    }
    return null;
  }

  _getCurrentLocation() async{
    var location = new Location();
    try {
      await location.getLocation().then((currentLocation){
        setState(() {
          _controllerLatitude.text = currentLocation.latitude.toString();
          _controllerLongitude.text = currentLocation.longitude.toString();
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        GeneralUtils.showToast(msg:"Permiso denegado");
        //error = 'Permission denied';
      }
    }
  }

  @override
  void onError(String error) {
    GeneralUtils.showToast(msg:"Ocurrio un error: $error");
  }

  @override
  void onSuccess() {
    _loading.hide(seconds: 1).whenComplete(() {
      GeneralUtils.showToast(msg:"Datos guardados satisfactoriamente");
      Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName,
              (Route<dynamic> route) => false);
    });
  }
}
