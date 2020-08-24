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

class TrackerHistory extends TrackerState {
  final Marker showMarker;
  final GoogleMapController controller;
  final List<TrackerStats> stats;

  TrackerHistory({ List<Location> locations, this.showMarker, this.controller, this.stats }) : super(locations ?? []);

  TrackerHistory copyWith(
    List<Location> locations, Marker showMarker,
    GoogleMapController controller, List<TrackerStats> stats
  ) {
    return TrackerHistory(
      locations: locations ?? this.locations,
      showMarker: showMarker ?? this.showMarker,
      controller: controller ?? this.controller,
      stats: stats ?? this.stats
    );
  }

  @override
  List<Object> get props => super.props..addAll([this.showMarker, this.controller, this.stats]);
}
