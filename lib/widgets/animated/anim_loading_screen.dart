import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {

  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<LoadingScreen> 
  with SingleTickerProviderStateMixin 
{
  AnimationController _controller;
  Animation<double> _spinAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() { setState(() {}); });
    _spinAnim = Tween<double>(begin: 0, end: pi * 2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  
}