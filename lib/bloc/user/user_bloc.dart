import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:urLife/data/repository/user_repository.dart';
import '../../models/Profile.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository _userRepository;

  UserBloc({ @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository;
  
  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if(event is UserEmptyProfile)
      yield* _mapUserEmptyProfileToState();
    if(event is UserProfileUpdate)
      yield* _mapUserProfileUpdateToState();
  }

  Stream<UserState> _mapUserEmptyProfileToState() {

  }

  Stream<UserState> _mapUserProfileUpdateToState() {
    
  }
}
