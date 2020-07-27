import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urLife/bloc/activity/activity_bloc.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/bloc/simple_bloc_observer.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/screens/home_screen.dart';
import 'package:urLife/screens/introduction_screen.dart';
import 'package:urLife/screens/login_screen.dart';
import 'package:urLife/screens/splash_screen.dart';
import 'package:urLife/utils/routes.dart';

import 'bloc/tracker/tracker_bloc.dart';

void main() {
  //required in Flutter v1.9.4+ before using any plugins IF CODE IS EXECUTED BEFORE runApp(..)
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();

  runApp(
    //will automatically close AuthBloc for us
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationStarted())),
        BlocProvider(create: (context) => ActivityBloc(),),
        BlocProvider(create: (context) => TrackerBloc(geolocator: Geolocator(), activityRepository: ActivityRepository()),),
      ],
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
            return state.displayName == null ?
            //if null this means they don't have a profile so set it up
              IntroductionScreen(userRepository: _userRepository,) :
            //otherwise they do, so take them to the home screen
              HomeScreen(name: state.displayName,);
          if(state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository);
          }

          return Text('Error: Could not match AuthenticationState');
        },
      ),
      routes: Routes.routes,
    );
  }
}