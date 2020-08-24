import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urLife/bloc/tracker/tracker_bloc.dart';
import 'package:urLife/data/repository/activity_repository.dart';
import 'package:urLife/widgets/tracker.dart';

class TrackerHistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ActivityRepository _activityRepository = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(title: Text('Activity Name'),),
      body: BlocBuilder<TrackerBloc, TrackerState>(
        builder: (context, state) {
          if(state is TrackerHistory) {
            final _markers = _genMarkers(state);
            final _media = MediaQuery.of(context);

            return Column(
              children: <Widget>[
                Expanded(
                  child: Tracker(
                    activityRepository: _activityRepository, 
                    markers: _markers, 
                    initPosition: LatLng(state.locations[0].lat, state.locations[0].lng),
                    showActions: false,
                )),
                Container(width: _media.size.width, height: _media.size.height * 0.4, child:ListView.builder(
                  itemCount: state.locations.length,
                  itemBuilder: (context, index) {
                    int i = state.locations.length - 1 - index;
                    bool isInRange = i >= 0 && i < state.stats.length;
                    
                    return ListTile(
                      title: Text("Position" + (index + 1).toString()),
                      subtitle: Column(children: <Widget>[
                        Text("Coordinates: " + state.locations[i].lat.toString() + ", " + state.locations[i].lng.toString()),
                        Text("Time: " + state.locations[i].time.toString()),
                        Text("Distance: " + (isInRange ? state.stats[i].totalMeters.toString() : "N/A")),
                        Text("Time Elapsed: " + (isInRange ? state.stats[i].totalSeconds.toString() : "N/A")),
                        Text("Speed: " + (isInRange ? state.stats[i].fastestSpeed.toString() : "N/A")),
                      ],),
                      onTap: () => BlocProvider.of<TrackerBloc>(context)
                        .add(ShowTrackerHistory(state.locations, marker: _markers.elementAt(i)
                          , controller: state.controller, stats: state.stats)),
                    );
                  }
                )),
              ],
            );
          }

          return CircularProgressIndicator();
        },
      )
    );
  }

  Set<Marker> _genMarkers(TrackerState state) {
    Set<Marker> markers = Set();
    int index = 0;

    if(state.locations == null || state.locations.isEmpty) {}
    else {
      state.locations.forEach((loc) {
        final marker = Marker(
          markerId: MarkerId("marker" + index.toString()),
          position: LatLng(loc.lat, loc.lng),
          infoWindow: InfoWindow(title: index.toString(), snippet: index.toString()),
        );
        markers.add(marker);
        index++;
      });
    }

    return markers;
  }
}