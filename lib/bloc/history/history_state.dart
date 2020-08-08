part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  @override
  List<Object> get props => [];
}

class HistoryLoading extends HistoryState {
  @override
  List<Object> get props => [];
}

class HistoryError extends HistoryState {
  final String errMsg;

  HistoryError(this.errMsg);
  
  @override
  List<Object> get props => [errMsg];
}

class HistoryActivity extends HistoryState {
  final List<Activity> activities;

  HistoryActivity(this.activities);

  @override
  List<Object> get props => [activities];
}
