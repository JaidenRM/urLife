import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/utils/validators.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({ @required UserRepository userRepository })
    : assert(userRepository != null),
      _userRepository = userRepository;
  
  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn
  ) {
    final debounceStream = events.where((event) => 
      event is! RegisterEmailChanged && event is! RegisterPasswordChanged
    );
    final nonDebounceStream = events.where((event) => 
      event is RegisterEmailChanged || event is RegisterPasswordChanged
    ).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if(event is RegisterEmailChanged) 
      yield* _mapRegisterEmailChangedToState(event.email);
    else if(event is RegisterPasswordChanged) 
      yield* _mapRegisterPasswordChangedToState(event.password);
    else if(event is RegisterSubmitted) 
      yield* _mapRegisterSubmittedToState(event.email, event.password);
  }

  Stream<RegisterState> _mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email)
    );
  }

  Stream<RegisterState> _mapRegisterPasswordChangedToState(String password) async* {
    yield state.update(
      isEmailValid: Validators.isValidPassword(password)
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(String email, String password) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
      );
      yield RegisterState.success();
    } catch(_) {
      yield RegisterState.failure();
    }
  }
}
