part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  final String activityName;

  const ActivityState(this.activityName);
  
  @override
  List<Object> get props => [activityName];
}

class ActivityInitial extends ActivityState {
  ActivityInitial(String activityName) : super(activityName);
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
  final bool isLocked;

  ActivityTracker(String activityName, this.isLocked) : super(activityName);

  @override
  List<Object> get props => super.props..add(isLocked);
}
