import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({ Key key, @required this.name }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      body: Column(
        children: <Widget>[
          Center(child: Text('Welcome $name!')),
        ],
      ),
    );
  }
}