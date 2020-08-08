import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/models/activity.dart';

part 'history_event.dart';
part 'history_state.dart';

enum History {
  activity
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ActivityRepository _activityRepository;
  
  HistoryBloc({ @required ActivityRepository activityRepository }) 
    : assert(activityRepository != null),
      _activityRepository = activityRepository,
      super(HistoryInitial());

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    if(event is GetHistory) {
      yield* _mapGetHistoryToState(event.type);
    }
  }

  Stream<HistoryState> _mapGetHistoryToState(History type) async* {

    switch(type) {
      case History.activity:
        final activities = await _activityRepository.getAllActivities();
        yield HistoryActivity(activities);
        break;
      default:
        yield HistoryError("Could not map GetHistory() to a History enum/type");
        break;
    }
  }
}
