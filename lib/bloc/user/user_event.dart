part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  
  @override
  get props => [];
}

//basically used to indicate a new user has joined and show them the intro
class UserEmptyProfile {}

class UserProfileUpdate {}