part of 'authentication_bloc.dart';

//need equatable as default use of '==' will only return true is they are the same instance
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  //this is what will be used to compare if two instances of same class are equal
  //so override this to add features that should be compared to determine equality
  @override
  List<Object> get props => [];
}

//waiting to see if the user is authenticated or not on app start
class AuthenticationInitial extends AuthenticationState {}

//successfully authenticated
class AuthenticationSuccess extends AuthenticationState {
  final String displayName;

  const AuthenticationSuccess(this.displayName);

  @override
  List<Object> get props => [displayName];

  //overriden for easier time reading when printing to console or in Transitions
  @override
  String toString() => 'Authentication Success { displayName: $displayName }';
}

//not authenticated
class AuthenticationFailure extends AuthenticationState {}