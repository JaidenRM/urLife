part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//check if user is authenticated or not
class AuthenticationStarted extends AuthenticationEvent{}
//user has successfully logged in
class AuthenticationLoggedIn extends AuthenticationEvent{}
//user has successfully logged out
class AuthenticationLoggedOut extends AuthenticationEvent{}