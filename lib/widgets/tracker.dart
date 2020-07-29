import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class Tracker extends StatelessWidget {

  Widget build(BuildContext context) {
    return BlocBuilder<TrackerBloc, TrackerState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget> [
            GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(target: LatLng(-37.813629, 144.963058), zoom: 15),
              polylines: _getPolylines(state),
            ),
            //add timer too i guess
            _getActions(context, state),
          ]
        );
      },
    );
  }

  Set<Polyline> _getPolylines(TrackerState state) {
    Set<Polyline> polylines = Set();
    List<LatLng> locations = [];

    if(state.locations == null || state.locations.length == 0) 
      return polylines;

    state.locations.forEach(
      (loc) => locations.add(LatLng(loc.lat, loc.lng))
    );

    polylines.add(Polyline(
      polylineId: PolylineId("track1"),
      color: Colors.blue,
      width: 3,
      points: locations,
    ));

    return polylines;
  }

  Widget _getActions(BuildContext context, TrackerState state) {
    List<Widget> actions = <Widget> [
      IconButton(
        icon: Icon(Icons.replay, size: Constants.SIZE_ICON_MD,),
        onPressed: () => BlocProvider.of<TrackerBloc>(context).add(TrackerReset()),
      ),
    ];
    
    //if state is this then no actions should be present except reset
    if(state is TrackerFinishing) {}
    else {
      if(state is TrackerPausing)
        actions.add(
          IconButton(
            icon: Icon(Icons.play_arrow, size: Constants.SIZE_ICON_MD,),
            onPressed: () => BlocProvider.of<TrackerBloc>(context).add(TrackerResumed()),
        ));
      else
        actions.add(
          IconButton(
            icon: Icon(Icons.pause, size: Constants.SIZE_ICON_MD,),
            onPressed: () => BlocProvider.of<TrackerBloc>(context).add(TrackerPaused()),
        ));

      actions.addAll(
        <Widget>[
          IconButton(
            icon: Icon(Icons.stop, size: Constants.SIZE_ICON_MD,),
            onPressed: () => BlocProvider.of<TrackerBloc>(context).add(TrackerFinished()),
          ),
        ]
      );
    }   

    return Padding(
      padding: EdgeInsets.all(12.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: actions,
      )
    );
  }
}