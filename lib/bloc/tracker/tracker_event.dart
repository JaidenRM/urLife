part of 'tracker_bloc.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object> get props => [];
}

class TrackerReadied extends TrackerEvent {}

class TrackerStarted extends TrackerEvent {}

class TrackerPaused extends TrackerEvent {}

class TrackerResumed extends TrackerEvent {}

class TrackerReset extends TrackerEvent {}

class TrackerFinished extends TrackerEvent {
  final List<Location> locations;

  TrackerFinished(this.locations);

  @override
  List<Object> get props => [locations];
}

class TrackerLocation extends TrackerEvent {
  final Location location;

  const TrackerLocation(this.location);

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'TrackerLocation { location: $location }';
}

class ShowTrackerHistory extends TrackerEvent {
  final List<Location> locations;
  final Marker marker;
  final GoogleMapController controller;

  ShowTrackerHistory(this.locations, { this.marker, this.controller });
}
