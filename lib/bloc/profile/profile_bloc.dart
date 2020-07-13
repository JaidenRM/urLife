import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/models/Profile.dart';
import 'package:urLife/utils/validators.dart';
import '../../utils/constants.dart' as Constants;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({ @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository;
  
  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if(event is ProfileTextChanged)
      yield* _mapProfileTextChangedToState(
        firstName: event.firstName, lastName: event.lastName,
        height: event.height, weight: event.weight, age: event.age
      );
    if(event is ProfileUpdated)
      yield* _mapProfileUpdatedToState(
        firstName: event.firstName, lastName: event.lastName,
        height: event.height, weight: event.weight, age: event.age
      );
    if(event is ProfileSaved)
      yield* _mapProfileSavedToState();
  }

  Stream<ProfileState> _mapProfileTextChangedToState({
    String firstName, String lastName, String email,
    String height, String weight, String age
  }) async* {
    yield state.update(
      isFirstNameValid: firstName == null ? state.isFirstNameValid : Validators.isValidAlpha(firstName, maxLength: Constants.MAX_NAME_LENGTH),
      isLastNameValid: lastName == null ? state.isLastNameValid : Validators.isValidAlpha(lastName, maxLength: Constants.MAX_NAME_LENGTH),
      isHeightValid: height == null ? state.isHeightValid : Validators.isValidNum(height),
      isWeightValid: weight == null ? state.isWeightValid : Validators.isValidNum(weight),
      isAgeValid: age == null ? state.isAgeValid : Validators.isValidNum(age, minValue: Constants.MIN_AGE, maxValue: Constants.MAX_AGE)
    );
  }

  Stream<ProfileState> _mapProfileUpdatedToState({
    String firstName, String lastName, String email,
    String height, String weight, String age
  }) async* {
    yield ProfileState.loading();
    try {  
      final Profile profile = Profile(
        firstName: firstName,
        lastName: lastName,
        height: int.tryParse(height),
        weight: int.tryParse(weight),
        age: int.tryParse(age)
      );
      final isSucc = await _userRepository.addOrUpdateUser(profile);
      yield isSucc ? ProfileState.success() : ProfileState.failure();
    } catch(_) {
      yield ProfileState.failure();
    }
  }

  Stream<ProfileState> _mapProfileSavedToState() async * {
    yield ProfileState.saved();
  }
}
