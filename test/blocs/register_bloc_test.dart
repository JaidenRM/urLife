import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:urLife/bloc/register/register_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('RegisterBloc', () {
    UserRepository userRepository;
    RegisterBloc registerBloc;
    const String _validEmail = "validemail@email.com";
    const String _validPassword = "validpwd";
    const String _invalidEmail = "invalid";
    const String _invalidPassword = "invalid";

    setUp(() {
      userRepository = MockUserRepository();
      registerBloc = RegisterBloc(userRepository: userRepository);
    });

    blocTest('Test initial state',
      build: () async => registerBloc,
      skip: 0,
      expect: [RegisterState.initial()]
    );

    blocTest('signup success',
      build: () async {
        when(userRepository.signUp(email: anyNamed("email"), password: anyNamed("password")))
          .thenReturn(null);
        
        return registerBloc;
      },
      act: (bloc) => bloc.add(RegisterSubmitted(email: _validEmail, password: _validPassword)),
      expect: [RegisterState.loading(), RegisterState.success()],
      wait: Duration(milliseconds: 500)
    );

    blocTest('signup failure',
      build: () async {
        when(userRepository.signUp(email: anyNamed("email"), password: anyNamed("password")))
          .thenThrow(Exception());
        
        return registerBloc;
      },
      act: (bloc) => bloc.add(RegisterSubmitted(email: _invalidEmail, password: _invalidPassword)),
      expect: [RegisterState.loading(), RegisterState.failure()],
      wait: Duration(milliseconds: 500)
    );
  });
}