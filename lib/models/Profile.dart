import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String firstName;
  final String lastName;

  final int height;
  final int weight;
  final int age;

  bool get _canCalcBMI => weight == null || height == null || height == 0;
  num get bodyMassIndex => _canCalcBMI ? weight / pow(height, 2) : null;

  DocumentReference docRef;

  Profile({ 
    this.firstName, this.lastName,
    this.height, this.weight, this.age  
  });

  factory Profile.fromSnapshot(DocumentSnapshot snapshot) {
    Profile ssProfile = Profile.fromJson(snapshot.data);
    ssProfile.docRef = snapshot.reference;
    return ssProfile;
  }
  factory Profile.fromJson(Map<dynamic, dynamic> json) => _profileFromJson(json);
  Map<String, dynamic> toJson() => _profileToJson(this);

  @override
  List<Object> get props => [
    firstName, lastName,
    height, weight, age
  ];

  @override
  toString() => '''Profile { 
      firstName: $firstName, lastName: $lastName,
      height: $height, weight: $weight, age: $age 
    }''';
}

//helpers
Map<String, dynamic> _profileToJson(Profile profile) =>
  <String, dynamic> {
    'firstName': profile.firstName,
    'lastName': profile.lastName,
    'height': profile.height,
    'weight': profile.weight,
    'age': profile.age
  };

Profile _profileFromJson(Map<dynamic, dynamic> json) =>
  Profile(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    height: json['height'] as int,
    weight: json['weight'] as int,
    age: json['age'] as int
  );