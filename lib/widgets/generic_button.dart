import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _buttonText;

  GenericButton({ Key key, VoidCallback onPressed, String buttonText })
    : _onPressed = onPressed,
      _buttonText = buttonText ?? "Button",
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: _onPressed,
      child: Text(_buttonText),
    );
  }
}