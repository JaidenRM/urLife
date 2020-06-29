part of 'login_bloc.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  //initial
  factory LoginState.initial() =>
    LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );

  //when we are validating credentials
  factory LoginState.loading() =>
    LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );

  //login has failed
  factory LoginState.failure() =>
    LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );

  //login has succeeded
  factory LoginState.success() =>
    LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmittedEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
