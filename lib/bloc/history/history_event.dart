part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class GetHistory extends HistoryEvent {
  final History type;

  GetHistory(this.type);

  @override
  List<Object> get props => [type];
}
