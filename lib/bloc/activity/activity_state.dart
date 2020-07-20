part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  
  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityError extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivitySelector extends ActivityState {
  final String activityName;

  ActivitySelector(this.activityName);

  factory ActivitySelector.update(String activity) => ActivitySelector(activity);

  @override
  List<Object> get props => [activityName];
}

class ActivityTracker extends ActivityState {
  final String activityName;

  ActivityTracker(this.activityName);

  @override
  List<Object> get props => [activityName];
}
