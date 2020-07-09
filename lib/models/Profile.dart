import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String firstName;
  final String lastName;
  final String email;

  final int height;
  final int weight;
  final int age;

  Profile({ 
    this.firstName, this.lastName, this.email, 
    this.height, this.weight, this.age  
  });

  @override
  List<Object> get props => [
    firstName, lastName, email,
    height, weight, age
  ];

  @override
  toString() => '''Profile { 
      firstName: $firstName, lastName: $lastName, email: $email,
      height: $height, weight: $weight, age: $age 
    }''';
}