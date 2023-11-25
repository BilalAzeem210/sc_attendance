import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapReviewScreen extends StatefulWidget {
  const MapReviewScreen({Key? key}) : super(key: key);

  @override
  State<MapReviewScreen> createState() => _MapReviewScreenState();
}

class _MapReviewScreenState extends State<MapReviewScreen> {
  Completer<GoogleMapController> _completer = Completer<GoogleMapController>();
  List<Marker> _Markers = [
    Marker(position: const LatLng(24.9323526,67.0872638),
        markerId: MarkerId("1")
    ),
    Marker(position: const LatLng(24.9435357,67.0471933),
        markerId: MarkerId("2")
    )
  ];
  CameraPosition _initialCameraPosition = const CameraPosition(target: LatLng(
      24.9435357,67.0471933
  ),
      zoom: 12
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: _Markers.toSet(),
          onMapCreated: (controller){
            _completer.complete(controller);
          },
          mapType: MapType.normal,
          compassEnabled: true,
        ),
      ),
    );
  }
}
