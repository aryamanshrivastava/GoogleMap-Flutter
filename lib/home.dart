// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _defaultLat = 13.082680;
  static const double _defaultLng = 80.270721;
  static const CameraPosition _defaultLocation =
      CameraPosition(target: LatLng(_defaultLat, _defaultLng), zoom: 15);
  late final GoogleMapController _googleMapController;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  void _addMarker() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('defaultLocation'),
          position: _defaultLocation.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: 'Really cool place',
            snippet: '5 Star Rating',
          )));
    });
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> _moveToNewLocation() async {
    const newPosition = LatLng(40.7128, -74.0060);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
    setState(() {
      const marker = Marker(
        markerId: MarkerId('newLocation'),
        position: newPosition,
        infoWindow: InfoWindow(title: 'New York', snippet: 'The Best Place'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }

  Future<void> _goToDefaultLocation() async {
    const defaultPosition = LatLng(_defaultLat, _defaultLng);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(defaultPosition, 15));
    setState(() {
      const marker = Marker(
        markerId: MarkerId('My Default Location'),
        position: defaultPosition,
        infoWindow: InfoWindow(title: 'Home', snippet: 'The Best Place'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Flutter Map'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: ((controller) => _googleMapController = controller),
              initialCameraPosition: _defaultLocation,
              mapType: _currentMapType,
              markers: _markers,
            ),
            Container(
              padding: EdgeInsets.only(top: 24, right: 12),
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: _changeMapType,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.map, size: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton(
                    onPressed: _addMarker,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Icon(Icons.add_location, size: 36),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton(
                    onPressed: _moveToNewLocation,
                    backgroundColor: Colors.indigoAccent,
                    child: Icon(Icons.location_city, size: 36),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton(
                    onPressed: _goToDefaultLocation,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.home_rounded, size: 36),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
