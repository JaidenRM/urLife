import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class AnimatedIconButtonLeftCenter extends StatefulWidget {
  final Icon _icon;
  final VoidCallback _onPressed;
  final double _iconSize;

  AnimatedIconButtonLeftCenter({ Key key, @required Icon icon, VoidCallback onPressed, double iconSize })
  : assert(icon != null),
    _icon = icon,
    _onPressed = onPressed,
    _iconSize = iconSize,
    super(key: key);

  @override
  createState() => _FromLeftToCenterAnimationState(icon: _icon, onPressed: _onPressed, iconSize: _iconSize);
}

class _FromLeftToCenterAnimationState extends State<AnimatedIconButtonLeftCenter>
  with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> l2CAnimation;
  Animation<double> scaleAnimation;

  Icon _icon;
  VoidCallback _onPressed;
  double _iconSize;

  _FromLeftToCenterAnimationState({ @required Icon icon, VoidCallback onPressed, double iconSize })
  : assert(icon != null),
    _icon = icon,
    _onPressed = onPressed,
    _iconSize = iconSize;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 750))
      ..addListener(() { setState(() {}); });
    l2CAnimation = Tween<double>(begin: -0.5, end: 0).animate(controller);
    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Transform(
      transform: Matrix4.compose(
        Vector3(l2CAnimation.value * screenWidth, 0, 0), //translation
        Quaternion.identity(), //rotation
        Vector3(scaleAnimation.value, scaleAnimation.value, 0), //scale
      ),
      child: IconButton(
        iconSize: _iconSize ?? 48,
        icon: _icon,
        onPressed: () {
          if(_onPressed != null) {
            controller.reverse();
            Future.delayed(Duration(milliseconds: 751))
              .then((value) => _onPressed());
          }
        },
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}