part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  final String activityName;

  const ActivityState(this.activityName);
  
  @override
  List<Object> get props => [activityName];
}

class ActivityInitial extends ActivityState {
  ActivityInitial() : super("");
}

class ActivityError extends ActivityState {
  ActivityError() : super("Error");
}

class ActivityLoading extends ActivityState {
  ActivityLoading() : super("Loading...");
}

class ActivitySelector extends ActivityState {

  ActivitySelector(String activityName) : super(activityName);

  factory ActivitySelector.update(String activity) => ActivitySelector(activity);

}

class ActivityTracker extends ActivityState {

  ActivityTracker(String activityName) : super(activityName);
}
