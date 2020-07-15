import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final VoidCallback _callback;
  final String _text;
  final AssetImage _image;

  ImageButton({ Key key, @required AssetImage image, String text, VoidCallback onPressed })
    : assert(image != null),
      _image = image,
      _callback = onPressed,
      _text = text,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(8.0),
      textColor: Colors.white,
      splashColor: Colors.greenAccent,
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: _image,
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_text),
        ),
      ),
      onPressed: _callback,
    );
  }
  
}