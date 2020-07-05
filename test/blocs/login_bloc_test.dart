import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:urLife/bloc/login/login_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('LoginBloc', () {
    UserRepository userRepository;
    LoginBloc loginBloc;

    setUp(() {
      userRepository = MockUserRepository();
      loginBloc = LoginBloc(userRepository: userRepository);
    });

    blocTest('initial state',
      build: () async => loginBloc,
      skip: 0,
      expect: [LoginState.initial()]
    );

    blocTest('GoogleSignIn success',
      build: () async {
        when(userRepository.signInWithGoogle())
          .thenAnswer((_) => null);
        
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginWithGooglePressed()),
      expect: [LoginState.success()],
      wait: const Duration(milliseconds: 500)
    );

    blocTest('GoogleSignIn failure',
      build: () async {
        when(userRepository.signInWithGoogle())
          .thenThrow(Exception());
        
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginWithGooglePressed()),
      expect: [LoginState.failure()],
      wait: const Duration(milliseconds: 500)
    );

    //work out later
    // blocTest('invalid email', 
    //   build: () async {
    //     return loginBloc;
    //   },
    //   act: (bloc) => bloc.add(LoginEmailChanged(email: 'False')),
    //   skip: 0,
    //   wait: const Duration(milliseconds: 600),
    //   expect: [
    //     LoginState(
    //       isEmailValid: false,
    //       isPasswordValid: true,
    //       isSubmitting: false,
    //       isSuccess: false,
    //       isFailure: false,
    //     ),
    //   ]
    // );

    // blocTest('valid email', 
    //   build: () async {
    //     return loginBloc;
    //   },
    //   act: (bloc) => bloc.add(LoginEmailChanged(email: 'true@true.com')),
    //   skip: 0,
    //   wait: const Duration(milliseconds: 600),
    //   expect: [
    //     LoginState(
    //       isEmailValid: true,
    //       isPasswordValid: true,
    //       isSubmitting: false,
    //       isSuccess: false,
    //       isFailure: false,
    //     ),
    //   ]
    // );

    // blocTest('invalid password', 
    //   build: () async {
    //     return loginBloc;
    //   },
    //   act: (bloc) async => await bloc.add(LoginPasswordChanged(password: 'False')),
    //   skip: 0,
    //   wait: const Duration(milliseconds: 600),
    //   expect: [
    //     LoginState(
    //       isEmailValid: true,
    //       isPasswordValid: false,
    //       isSubmitting: false,
    //       isSuccess: false,
    //       isFailure: false,
    //     ),
    //   ]
    // );

    // blocTest('valid password', 
    //   build: () async {
    //     return loginBloc;
    //   },
    //   act: (bloc) => bloc.add(LoginPasswordChanged(password: 'TrueTrue')),
    //   skip: 0,
    //   wait: const Duration(milliseconds: 600),
    //   expect: [
    //     LoginState(
    //       isEmailValid: true,
    //       isPasswordValid: true,
    //       isSubmitting: false,
    //       isSuccess: false,
    //       isFailure: false,
    //     ),
    //   ]
    // );

  });
}