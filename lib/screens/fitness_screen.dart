import 'package:flutter/material.dart';
import 'package:urLife/widgets/generic_button.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class FitnessScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fitness'),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GenericButton(
                buttonText: Text('New activity'),
                onPressed: () => Navigator.of(context).pushNamed(Constants.ROUTE_ACTIVITY),
              ),
              GenericButton(
                buttonText: Text('View history'),
                onPressed: () => Navigator.of(context).pushNamed(Constants.ROUTE_ACTIVITY_HISTORY),
              ),
              GenericButton(
                buttonText: Text('View stats/PBs'),
              ),
            ],
          ),
        )
      )
    );
  }
}