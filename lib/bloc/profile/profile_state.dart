part of 'profile_bloc.dart';

@immutable
class ProfileState extends Equatable{
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isHeightValid;
  final bool isWeightValid;
  final bool isAgeValid;

  final bool isSubmitting;
  final bool isSaved;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isFirstNameValid && isLastNameValid && 
    isHeightValid && isWeightValid && isAgeValid;

  @override
  List<Object> get props => [
    isFirstNameValid, isLastNameValid,
    isHeightValid, isWeightValid, isAgeValid,
    isSubmitting, isSaved, isSuccess, isFailure
  ];

  ProfileState({
    @required this.isFirstNameValid,
    @required this.isLastNameValid,
    @required this.isHeightValid,
    @required this.isWeightValid,
    @required this.isAgeValid,
    @required this.isSubmitting,
    @required this.isSaved,
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
      isSaved: false,
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
      isSaved: false,
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
      isSaved: false,
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
      isSaved: false,
      isSuccess: true,
      isFailure: false,
    );
    
  //Profile has succeeded
  factory ProfileState.saved() =>
    ProfileState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isHeightValid: true,
      isWeightValid: true,
      isAgeValid: true,
      isSubmitting: false,
      isSaved: true,
      isSuccess: false,
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
      isSaved: false,
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
    bool isSaved,
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
      isSaved: isSaved ?? this.isSaved,
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
      isSaved: $isSaved,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}