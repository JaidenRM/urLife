import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urLife/models/profile.dart';

//this could be done via a BLoC but Profile can handle all the business logic
class BMI extends StatefulWidget {
  final Profile _profile;

  BMI({ Key key, Profile profile })
    : _profile = profile,
      super(key: key);

  @override
  State<StatefulWidget> createState() => _BMIState(profile: _profile);
}

class _BMIState extends State<BMI>
  with SingleTickerProviderStateMixin {
  Profile profile;
  bool isAnimFinished;
  
  AnimationController controller;
  Animation loadingAnim;

  _BMIState({ this.profile });

  @override
  void initState() {
    super.initState();
    isAnimFinished = false;
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 750))
      ..addListener(() { setState((){}); });
    loadingAnim = Tween<double>(begin: 0, end: 2 * pi).animate(controller);

    TickerFuture tickerFuture = controller.repeat();
    tickerFuture.timeout(Duration(milliseconds: 4 * 750), onTimeout: () {
      controller.forward(from: 0);
      controller.stop(canceled: true);
    }).whenComplete(() => isAnimFinished = true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('BMI', style: TextStyle(fontSize: 56),),
            isAnimFinished
            ?
              //bmi
              Text((profile.bodyMassIndex ?? 'N/A').toString(), style: TextStyle(fontSize: 69),)
            :
              //loading
              Transform.rotate(
                angle: loadingAnim.value,
                child: Icon(FontAwesomeIcons.atom, size: 96,),
              ),
          ],)
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}