part of 'tracker_bloc.dart';

abstract class TrackerState extends Equatable {
  final List<Location> locations;
  
  const TrackerState(this.locations);
  
  @override
  List<Object> get props => [locations];
}

class TrackerInitial extends TrackerState {
  TrackerInitial() : super([]);

  @override
  String toString() => 'TrackerInitial';
}

class TrackerReady extends TrackerState {
  TrackerReady({ Location currLocation }) : super([currLocation]);

  @override
  String toString() => 'TrackerReady { currLocation: $locations }';
}

class TrackerRunning extends TrackerState {
  TrackerRunning({ List<Location> locations }) : super(locations ?? []);

  @override
  String toString() => 'TrackerRunning { locations: $locations }';
}

class TrackerPausing extends TrackerState {
  TrackerPausing({ List<Location> locations }) : super(locations ?? []);

  @override
  String toString() => 'TrackerPausing { locations: $locations }';
}

class TrackerFinishing extends TrackerState {
  TrackerFinishing({ List<Location> locations }) : super(locations ?? []);

  @override
  String toString() => 'TrackerFinishing { locations: $locations }';
}
