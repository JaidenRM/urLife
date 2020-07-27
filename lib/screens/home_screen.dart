import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urLife/bloc/activity/activity_bloc.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/widgets/generic_button.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({ Key key, @required this.name }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('urLife'),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            //can access it as it was injected earlier in main
            onPressed: () => BlocProvider
              .of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedOut()),
          )
        ],
      ),
      body:Align(
        alignment: Alignment.center, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 50.0, top: 10.0),
              child: Text('Welcome $name!', style: TextStyle(fontSize: 18),)
            ),
            GenericButton(
              richText: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(Icons.fitness_center)),
                    TextSpan(text: ' Fitness', style: TextStyle(color: Colors.black, fontSize: 24))
                  ]
                ),
              ),
              onPressed: () => Navigator.of(context).pushNamed(Constants.ROUTE_FITNESS),
            ),
          ],
        )
      ),
    );
  }
}