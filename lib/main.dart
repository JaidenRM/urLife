import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/simple_bloc_delegate.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/screens/home_screen.dart';
import 'package:urLife/screens/login_screen.dart';
import 'package:urLife/screens/splash_screen.dart';

void main() {
  //required in Flutter v1.9.4+ before using any plugins IF CODE IS EXECUTED BEFORE runApp(..)
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();

  runApp(
    //will automatically close AuthBloc for us
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({ Key key, @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //blocbuilder so we rebuild on state/event change loop
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is AuthenticationInitial)
            return SplashScreen();
          if(state is AuthenticationSuccess)
            return HomeScreen(name: state.displayName,);
          if(state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository);
          }

          return Text('Error: Could not match AuthenticationState');
        },
      )
    );
  }
}