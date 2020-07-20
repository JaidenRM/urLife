part of 'tracker_bloc.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object> get props => [];
}

class TrackerStarted extends TrackerEvent {}

class TrackerEnded extends TrackerEvent {}