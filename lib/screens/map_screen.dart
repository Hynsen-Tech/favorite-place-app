import 'package:favorite_place_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location =
        const PlaceLocation(latitude: 37.422, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Choose your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedPosition);
              },
            )
        ],
      ),
      body: GoogleMap(
        onTap: (position) {
          setState(() {
            _pickedPosition = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: (_pickedPosition == null && widget.isSelecting) ? {} : {
          Marker(
            markerId: const MarkerId('ID'),
            position: _pickedPosition ?? LatLng(
              widget.location.latitude,
              widget.location.longitude,
            ),
          ),
        },
      ),
    );
  }
}
