import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urLife/bloc/history/history_bloc.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class ActivityHistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity History'),),
      body: BlocBuilder<HistoryBloc, HistoryState> (
        builder: (context, state) {
          if(state is HistoryInitial) {
            BlocProvider.of<HistoryBloc>(context).add(GetHistory(History.activity));
            return CircularProgressIndicator();
          } else if(state is HistoryError) {
            return Text("Oops. An error has occurred. Please try again", style: TextStyle(fontSize: 16),);
          } else if(state is HistoryActivity) {
            return state.activities.isNotEmpty
            ?
              ListView.builder(
                itemCount: state.activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _getIcon(state.activities[index].activityName),
                    title: Text(state.activities[index].activityName),
                    subtitle: Text(state.activities[index].locations[0].time.toLocal().toString()),
                    onTap: () {
                      BlocProvider.of<TrackerBloc>(context).add(TrackerFinished(state.activities[index].locations));
                      Navigator.of(context).pushNamed(Constants.ROUTE_TRACKER_HISTORY, arguments: ActivityRepository());
                    },
                  );
                },
              )
            :
              null
            ;
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _getIcon(String activityName) {
    switch(activityName) {
      case Constants.ACT_CYCLE:
        return Icon(FontAwesomeIcons.bicycle);
      case Constants.ACT_JOG:
        return Icon(FontAwesomeIcons.running);
      case Constants.ACT_SPRINT:
        return Icon(Icons.flash_on);
      case Constants.ACT_WALK:
        return Icon(FontAwesomeIcons.walking);
      default:
        return null;
    }
  }
}