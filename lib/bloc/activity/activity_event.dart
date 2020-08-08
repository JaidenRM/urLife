part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivitySelected extends ActivityEvent {
  final String selectedActivity;

  ActivitySelected(this.selectedActivity);

  @override
  List<Object> get props => [selectedActivity];
}

class ActivityStarted extends ActivityEvent {
  final String selectedActivity;

  ActivityStarted(this.selectedActivity);

  @override
  List<Object> get props => [selectedActivity];
}

class ActivityEnded extends ActivityEvent {
  final String selectedActivity;

  ActivityEnded(this.selectedActivity);

  @override
  List<Object> get props => [selectedActivity];
}