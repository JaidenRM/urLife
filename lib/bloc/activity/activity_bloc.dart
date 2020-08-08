import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/utils/constants.dart' as Constants;

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final TrackerBloc _trackerBloc;
  final ActivityRepository _activityRepository;
  
  StreamSubscription _blocSubscription;
  
  ActivityBloc({ @required TrackerBloc trackerBloc, @required ActivityRepository activityRepository }) 
    : assert(trackerBloc != null && activityRepository != null),
      _trackerBloc = trackerBloc,
      _activityRepository = activityRepository,
      super(ActivityInitial(Constants.ACT_JOG));

  @override
  Stream<ActivityState> mapEventToState(ActivityEvent event,) async* {
    if(event is ActivitySelected)
      yield* _mapActivitySelectedToState(event.selectedActivity);
    if(event is ActivityStarted)
      yield* _mapActivityStartedToState(event.selectedActivity);
    if(event is ActivityEnded)
      yield* _mapActivityEndedToState(event.selectedActivity);
  }

  Stream<ActivityState> _mapActivitySelectedToState(String activity) async* {  
    yield ActivitySelector.update(activity);
  }

  Stream<ActivityState> _mapActivityStartedToState(String activity) async* {
    _blocSubscription?.cancel();
    _blocSubscription = _trackerBloc.listen((trackerState) {
      if(trackerState is TrackerFinishing) {
        _activityRepository.addActivity(Activity(
          activityName: activity,
          locations: trackerState.locations,
        ));
      }
    });
    yield ActivityTracker(activity, false);
  }

  Stream<ActivityState> _mapActivityEndedToState(String activity) async* {
    yield ActivityTracker(activity, true);
  }

  @override
  Future<void> close() {
    _blocSubscription?.cancel();
    return super.close();
  }
}
