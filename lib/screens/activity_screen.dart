import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urLife/bloc/activity/activity_bloc.dart';
import 'package:urLife/widgets/generic_button.dart';
import 'package:urLife/widgets/tracker.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class ActivityScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('New activity'),),
          body: Column(
            children: <Widget> [
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
              ),
              Expanded(child: Tracker()),
            ]
          ),
          floatingActionButton: GenericButton(
            buttonText: Text('Start'),
            onPressed: _startActivity,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      }
    );
  }

  void _startActivity() {

  }

  void _selectActivity(String activity, BuildContext context) {
    BlocProvider.of<ActivityBloc>(context).add(ActivitySelected(activity));
  }
}