import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/utils/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({ @required UserRepository userRepository})
    : assert(userRepository != null),
      _userRepository = userRepository,
      super(LoginState.initial());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => 
      event is! LoginEmailChanged && event is! LoginPasswordChanged
    );
    //we are debouncing these events so we give time for the user to type before we validate
    //ELI5: only validate when we think the user has stopped typing
    final debounceStream = events.where((event) => 
      event is LoginEmailChanged || event is LoginPasswordChanged
    ).debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is LoginEmailChanged)
      yield* _mapLoginEmailChangedToState(event.email);
    if(event is LoginPasswordChanged)
      yield* _mapLoginPasswordChangedToState(event.password);
    if(event is LoginWithGooglePressed)
      yield* _mapLoginWithGooglePressedToState();
    if(event is LoginWithCredentialsPressed)
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email, 
        password: event.password,
      );
  }

  Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapLoginPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch(_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email, 
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch(_) {
      yield LoginState.failure();
    }
  }
}
