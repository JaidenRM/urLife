import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:urLife/bloc/profile/profile_bloc.dart';
import 'package:urLife/data/repository/user_repository.dart';
import 'package:urLife/models/Profile.dart';

class MockRepository extends Mock implements UserRepository {}

void main() {
  Profile validProfile = Profile(firstName: "J", lastName: "M", age: 22, height: 186, weight: 86);
  group('ProfileBloc', () {
    UserRepository userRepository;
    ProfileBloc profileBloc;

    setUp(() {
      userRepository = MockRepository();
      profileBloc = ProfileBloc(userRepository: userRepository);
    });

    blocTest('Initial',
      build: () async => profileBloc,
      skip: 0,
      expect: [ProfileState.initial()]
    );

    blocTest('Saved',
      build: () async => profileBloc,
      act: (bloc) => bloc.add(ProfileSaved()),
      expect: [ProfileState.saved()],
      wait: Duration(milliseconds: 500),
    );

    blocTest('Update Success',
      build: () async {
        when(userRepository.addOrUpdateUser(validProfile))
          .thenAnswer((_) async => true);
        
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileUpdated(
        firstName: validProfile.firstName, lastName: validProfile.lastName,
        age: validProfile.age.toString(), height: validProfile.height.toString(),
        weight: validProfile.weight.toString() 
      )),
      expect: [ProfileState.loading(), ProfileState.success()],
      wait: Duration(milliseconds: 500),
    );

    blocTest('Update Failed',
      build: () async {
        when(userRepository.addOrUpdateUser(Profile()))
          .thenAnswer((_) async => false);

        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileUpdated()),
      expect: [ProfileState.loading(), ProfileState.failure()],
      wait: Duration(milliseconds: 500),
    );
  });
}