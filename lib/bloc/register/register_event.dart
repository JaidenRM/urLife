part of 'register_bloc.dart';

//SIMILAR TO LOGIN EVENT
//Again - better to decouple as likely to diverge
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

//event called when user changes their email
class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({ @required this.email });

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'RegisterEmailChanged { email: $email }';
}

//event called when user changes their password
class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({ @required this.password });

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegisterPasswordChanged { password: $password }';
}

//event called when user signs in with email/pwd combo
class RegisterSubmitted extends RegisterEvent {
  final String email, password;

  const RegisterSubmitted({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'RegisterSubmitted { email: $email, password: $password }';
}
