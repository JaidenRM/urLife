import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/screens/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({ Key key, @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create an Account'),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegisterScreen(userRepository: _userRepository)
        )
      ),
    );
  }
}