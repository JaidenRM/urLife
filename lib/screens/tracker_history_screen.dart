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
          if(state is TrackerFinishing || state is TrackerHistory) {
            final _markers = _genMarkers(state);

            return Column(
              children: <Widget>[
                Expanded(
                  child: Tracker(
                    activityRepository: _activityRepository, 
                    markers: _markers, 
                    initPosition: LatLng(state.locations[0].lat, state.locations[0].lng),
                )),
                Container(width: 300, height: 300, child:ListView.builder(
                  itemCount: state.locations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Position" + (index + 1).toString()),
                      subtitle: Column(children: <Widget>[
                        Text("Coordinates: " + state.locations[index].lat.toString() + ", " + state.locations[index].lng.toString()),
                        Text("Time: " + state.locations[index].time.toString()),
                      ],),
                      onTap: () => BlocProvider.of<TrackerBloc>(context)
                        .add(ShowTrackerHistory(state.locations, marker: _markers.elementAt(index)
                          , controller: (state is TrackerHistory) ? state.controller : null)),
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