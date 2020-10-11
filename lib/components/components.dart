import 'package:flutter/material.dart';

TextFormField customTextFormField({String labelText, TextInputType inputType,
    Function onsaved, Widget prefixIcon,String Function(String) validate}) {
  return TextFormField(validator: validate,
    onSaved: onsaved,
    keyboardType: inputType,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      border: InputBorder.none,
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

RaisedButton customButton({void Function() onPressed,String buttonText}) {
  return RaisedButton(
    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
    color: Colors.white,
    onPressed: onPressed,
    child: Text(
      '$buttonText',
      style: TextStyle(color: Colors.orange,fontSize: 20),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white)),
  );
}

