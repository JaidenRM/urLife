part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivitySelected extends ActivityEvent {
  final String selectedActivity;

  ActivitySelected(this.selectedActivity);
}

class ActivityStarted extends ActivityEvent {}

class ActivityEnded extends ActivityEvent {}