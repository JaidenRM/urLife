import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/utils/constants.dart' as Constants;

class Tracker extends StatelessWidget {
  final ActivityRepository _activityRepository;
  final bool _showPolylines, _showActions;
  final LatLng _initPos;
  final Set<Marker> _markers;

  Tracker({ 
    Key key, @required ActivityRepository activityRepository, bool showPolylines = true, 
    Set<Marker> markers, bool showActions = true, LatLng initPosition
  })
    : assert(activityRepository != null),
      _activityRepository = activityRepository,
      _showActions = showActions,
      _markers = markers,
      _showPolylines = showPolylines,
      _initPos = initPosition,
      super(key: key);

  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _mapController = Completer();

    return BlocConsumer<TrackerBloc, TrackerState>(
      listener: (context, state) async {
        if(state is TrackerHistory && state.controller != null && state.showMarker != null) {
          GoogleMapController controller = state.controller;
          _markers.forEach((m) async { 
            if(m.markerId != null && await controller.isMarkerInfoWindowShown(m.markerId))
              controller.hideMarkerInfoWindow(m.markerId);
          });
          controller.showMarkerInfoWindow(state.showMarker.markerId);
        }
          
      },
      builder: (context, state) {
        return Stack(
          //alignment: Alignment.bottomCenter,
          children: <Widget> [
            GoogleMap(
              onMapCreated: (controller) { 
                BlocProvider.of<TrackerBloc>(context).add(
                  ShowTrackerHistory(state.locations, controller: controller));
                _mapController.complete(controller);
              },
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _initPos == null ? 
                  LatLng(-37.813629, 144.963058) :
                  _initPos, 
                zoom: 15
              ),
              polylines: _showPolylines ? _getPolylines(state) : null,
              markers: _markers,
            ),
            //add timer too i guess
            if(_showActions) _getActions(context, state),
            _getStatsMenu(state),
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
            onPressed: () => BlocProvider.of<TrackerBloc>(context).add(TrackerFinished(state.locations)),
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

  Widget _getStatsMenu(TrackerState state) {
    var mappedStats = <Widget>[];
    var statsMap = _activityRepository.calcTrackerStats(state.locations, true, activityName: "Jog", weight: 86);
    
    if(statsMap != null && statsMap.toMap().isNotEmpty) {
      statsMap.toMap().forEach((key, value) => mappedStats
        .add(
          Container(
            child: Column(
              children: <Widget>[
                Text(key, style: TextStyle(fontSize: 18),),
                Text(value.toString(), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
              ],
            ),
          )
        )
      );
    } else {
      mappedStats.add(Text("No data found...", style: TextStyle(fontSize: 28),));
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 1,
      builder: (context, controller) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.start,
                spacing: 30.0,
                runSpacing: 30.0,
                children: mappedStats,
              ),
            ),
          )
        );
      },
    );
  }
}