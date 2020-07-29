import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/models/activity.dart';
import 'package:urLife/models/location.dart';
import 'package:urLife/services/location_service.dart';

part 'tracker_event.dart';
part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final LocationService _locationService;
  final ActivityRepository _activityRepository;

  StreamSubscription<Location> _locationSubscription;

  TrackerBloc({ 
    @required ActivityRepository activityRepository, 
    @required Geolocator geolocator, 
    Duration updateInterval 
  })
    : assert(geolocator != null),
      _locationService = LocationService(
        geolocator: geolocator, 
        updateInterval: updateInterval
      ),
      _activityRepository = activityRepository,
      super(TrackerInitial());

  @override
  void onTransition(Transition<TrackerEvent, TrackerState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<TrackerState> mapEventToState(
    TrackerEvent event,
  ) async* {
    if(event is TrackerReadied)
      yield* _mapTrackerReadiedToState();
    else if(event is TrackerStarted)
      yield* _mapTrackerStartedToState();
    else if(event is TrackerLocation)
      yield* _mapTrackerLocationToState(event);
    else if(event is TrackerPaused)
      yield* _mapTrackerPausedToState();
    else if(event is TrackerResumed)
      yield* _mapTrackerResumedToState();
    else if(event is TrackerReset)
      yield* _mapTrackerResetToState();
    else if(event is TrackerFinished)
      yield* _mapTrackerFinishedToState();
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  Stream<TrackerState> _mapTrackerReadiedToState() async* {
    yield TrackerReady(
      currLocation: await _locationService.getCurrentLocation()
    );
  }

  Stream<TrackerState> _mapTrackerStartedToState() async* {
    yield TrackerRunning();
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.onChange().listen(
      (location) {
        add(TrackerLocation(location));
      }
    );
  }

  Stream<TrackerState> _mapTrackerLocationToState(TrackerLocation event) async* {
    //add new location into list of previous ones
    List<Location> locations = [];
    if(event.location != null)
      locations.add(event.location);
    if(state.locations != null && state.locations.length > 0)
      locations.addAll(state.locations);

    yield TrackerRunning(locations: locations);
  }

  Stream<TrackerState> _mapTrackerPausedToState() async* {
    if(state is TrackerRunning) {
      _locationSubscription?.pause();
      yield TrackerPausing(locations: state.locations);
    }
  }

  Stream<TrackerState> _mapTrackerResumedToState() async* {
    if(state is TrackerPausing) {
      _locationSubscription?.resume();
      yield TrackerRunning(locations: state.locations);
    }
  }

  Stream<TrackerState> _mapTrackerResetToState() async* {
    _locationSubscription?.cancel();
    yield* _mapTrackerStartedToState();
  }

  Stream<TrackerState> _mapTrackerFinishedToState() async* {
    _locationSubscription?.cancel();
    _activityRepository.addActivity(Activity(activityName: "test", locations: state.locations));
    yield TrackerFinishing(locations: state.locations);
  }
}
