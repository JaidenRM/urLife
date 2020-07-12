part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  get props => [];
}

//event called when user changes their email
class ProfileTextChanged extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String height;
  final String weight;
  final String age;

  const ProfileTextChanged({ 
    this.firstName, this.lastName,
    this.height, this.weight, this.age 
  });

  @override
  List<Object> get props => [
    firstName, lastName,
    height, weight, age
  ];

  @override
  String toString() => '''ProfileTextChanged { 
    firstName: $firstName, lastName: $lastName,
    height: $height, weight: $weight, age: $age 
  }''';
}

class ProfileUpdated extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String height;
  final String weight;
  final String age;

  const ProfileUpdated({ 
    this.firstName, this.lastName,
    this.height, this.weight, this.age 
  });

  @override
  List<Object> get props => [
    firstName, lastName,
    height, weight, age
  ];

  @override
  String toString() => '''ProfileUpdating { 
    firstName: $firstName, lastName: $lastName,
    height: $height, weight: $weight, age: $age 
  }''';
}
