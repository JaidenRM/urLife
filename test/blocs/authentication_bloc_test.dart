import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/models/Profile.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  final Profile _user = Profile();

  group('AuthenticationBloc', () {
    UserRepository userRepository;
    AuthenticationBloc authenticationBloc;

    setUp(() {
      userRepository = MockUserRepository();
      authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    });

    blocTest('Test initial state',
      build: () async => authenticationBloc,
      expect: []
    );
    
    blocTest('Get signed-in user''s name',
      build: () async {
        when(userRepository.isSignedIn())
          .thenAnswer((_) async => true);
        when(userRepository.getUser())
          .thenAnswer((_) async => _user);
        
        return authenticationBloc;
      },
      act: (authenticationBloc) => authenticationBloc.add(AuthenticationStarted()),
      expect: [AuthenticationSuccess(_user.firstName)]
    );

    blocTest('Check failure when user isn''t signed in',
      build: () async {
        when(userRepository.isSignedIn())
          .thenAnswer((_) async => false);
        return authenticationBloc;
      },
      act: (authenticationBloc) => authenticationBloc.add(AuthenticationStarted()),
      expect: [AuthenticationFailure()]
    );

    blocTest('Check when user is signed in but getUser fails',
      build: () async {
        when(userRepository.isSignedIn())
          .thenAnswer((_) async => true);
        when(userRepository.getUser())
          .thenThrow((_) async => NullThrownError());
        return authenticationBloc;
      },
      act: (authenticationBloc) => authenticationBloc.add(AuthenticationStarted()),
      expect: [AuthenticationFailure()]
    );
    
    blocTest('User signs out',
      build: () async => authenticationBloc,
      act: (authenticationBloc) => authenticationBloc.add(AuthenticationLoggedOut()),
      expect: [AuthenticationFailure()]
    );
  });

}