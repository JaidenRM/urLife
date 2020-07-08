part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {}

class UserProfile extends UserState {
  final Profile profile;

  const UserProfile(this.profile);

  @override
  List<Object> get props => [profile];

  @override
  toString() => 'UserProfile { profile: ${profile.toString()} }';
}
