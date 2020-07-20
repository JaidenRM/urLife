import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial());

  @override
  Stream<ActivityState> mapEventToState(ActivityEvent event,) async* {
    if(event is ActivitySelected)
      yield* _mapActivitySelectedToState(event.selectedActivity);
    if(event is ActivityStarted)
      yield* _mapActivityStartedToState();
    if(event is ActivityEnded)
      yield* _mapActivityEndedToState();
  }

  Stream<ActivityState> _mapActivitySelectedToState(String activity) async* {  
    yield ActivitySelector.update(activity);
  }

  Stream<ActivityState> _mapActivityStartedToState() async* {
    yield null;
  }

  Stream<ActivityState> _mapActivityEndedToState() async* {
    yield null;
  }
}
