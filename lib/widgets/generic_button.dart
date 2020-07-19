import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final Text _buttonText;
  final RichText _richText;

  GenericButton({ Key key, VoidCallback onPressed, Text buttonText, RichText richText })
    : _onPressed = onPressed,
      _buttonText = buttonText ?? Text("Button"),
      _richText = richText,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: _onPressed,
      child: _richText ?? _buttonText,
    );
  }
}