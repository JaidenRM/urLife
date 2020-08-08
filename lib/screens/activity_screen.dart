import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/activity/activity_bloc.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/widgets/generic_button.dart';
import 'package:urLife/widgets/tracker.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class ActivityScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Activity Tracker'),),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              _getTopRow(context, state),
              Expanded(child: Tracker(activityRepository: ActivityRepository(),)),
              _getAction(context, state),
            ]
          ),
        );
      }
    );
  }

  Widget _getTopRow(BuildContext context, ActivityState state) {
    return state is ActivityTracker
      ?
        Text(state.activityName)
      :
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Going for a '),
            DropdownButton(
              value: state is ActivitySelector ? state.activityName : Constants.ACT_JOG,
              items: <String>[
                Constants.ACT_JOG, Constants.ACT_WALK,
                Constants.ACT_CYCLE, Constants.ACT_SPRINT,
              ]
                .map<DropdownMenuItem<String>>((text) =>
                  DropdownMenuItem<String>(
                    value: text,
                    child: Text(text), 
                  )
                ).toList(),
              onChanged: (String activity) => _selectActivity(activity, context),
            )
          ],
        );
  }

  Widget _getAction(BuildContext context, ActivityState state) {
    if(state is ActivityTracker) {
      return GenericButton(
        buttonText: Text('Start Tracker'),
        onPressed: () => _startTracker(context),
      );
    } else {
      return GenericButton(
        buttonText: Text('Confirm Activity'),
        onPressed: () => _startActivity(context, state),
      );
    }
  }
  
  void _startTracker(BuildContext context) {
    BlocProvider.of<TrackerBloc>(context).add(TrackerStarted());
  }

  void _startActivity(BuildContext context, ActivityState state) {
    BlocProvider.of<ActivityBloc>(context).add(ActivityStarted(state.activityName));
    BlocProvider.of<TrackerBloc>(context).add(TrackerReadied());
  }

  void _selectActivity(String activity, BuildContext context) {
    BlocProvider.of<ActivityBloc>(context).add(ActivitySelected(activity));
  }
}