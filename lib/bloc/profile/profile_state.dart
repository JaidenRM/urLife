part of 'profile_bloc.dart';

@immutable
class ProfileState extends Equatable{
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isHeightValid;
  final bool isWeightValid;
  final bool isAgeValid;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isFirstNameValid && isLastNameValid && 
    isHeightValid && isWeightValid && isAgeValid;

  @override
  List<Object> get props => [
    isFirstNameValid, isLastNameValid,
    isHeightValid, isWeightValid, isAgeValid,
    isSubmitting, isSuccess, isFailure
  ];

  ProfileState({
    @required this.isFirstNameValid,
    @required this.isLastNameValid,
    @required this.isHeightValid,
    @required this.isWeightValid,
    @required this.isAgeValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  //initial
  factory ProfileState.initial() =>
    ProfileState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isHeightValid: true,
      isWeightValid: true,
      isAgeValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );

  //when we are validating credentials
  factory ProfileState.loading() =>
    ProfileState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isHeightValid: true,
      isWeightValid: true,
      isAgeValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );

  //Profile has failed
  factory ProfileState.failure() =>
    ProfileState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isHeightValid: true,
      isWeightValid: true,
      isAgeValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );

  //Profile has succeeded
  factory ProfileState.success() =>
    ProfileState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isHeightValid: true,
      isWeightValid: true,
      isAgeValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );

  ProfileState update({
    bool isFirstNameValid,
    bool isLastNameValid,
    bool isEmailValid,
    bool isHeightValid,
    bool isWeightValid,
    bool isAgeValid,
  }) {
    return copyWith(
      isFirstNameValid: isFirstNameValid,
      isLastNameValid: isLastNameValid,
      isEmailValid: isEmailValid,
      isHeightValid: isHeightValid,
      isWeightValid: isWeightValid,
      isAgeValid: isAgeValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  ProfileState copyWith({
    bool isFirstNameValid,
    bool isLastNameValid,
    bool isEmailValid,
    bool isHeightValid,
    bool isWeightValid,
    bool isAgeValid,
    bool isSubmittedEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ProfileState(
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      isHeightValid: isHeightValid ?? this.isHeightValid,
      isWeightValid: isWeightValid ?? this.isWeightValid,
      isAgeValid: isAgeValid ?? this.isAgeValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''ProfileState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isHeightValid: $isHeightValid,
      isWeightValid: $isWeightValid,
      isAgeValid: $isAgeValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}