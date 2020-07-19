part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

//event called when user changes their email
class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({ @required this.email });

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'LoginEmailChanged { email: $email }';
}

//event called when user changes their password
class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({ @required this.password });

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'LoginPasswordChanged { password: $password }';
}

//event called when user signs in with Google
class LoginWithGooglePressed extends LoginEvent {}

//event called when user signs in with email/pwd combo
class LoginWithCredentialsPressed extends LoginEvent {
  final String email, password;

  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LoginWithCredentialsPressed { email: $email, password: $password }';
}
