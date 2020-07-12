//work on this next
  //not so much the UI but this can be a good step to check firebase is working ok
  //ask some basic info and/or weight, height, goals etc... 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/profile/profile_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/forms/profile_form.dart';

class IntroductionScreen extends StatelessWidget {
  final UserRepository _userRepository;

  IntroductionScreen({ Key key, @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create your profile')),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(userRepository: _userRepository),
        child: ProfileForm(userRepository: _userRepository,),
      )
    );
  }

}