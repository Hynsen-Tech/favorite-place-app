import 'dart:convert';

import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({required this.onSelectLocation, super.key});

  final void Function(PlaceLocation) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    } else {
      double lat = _pickedLocation!.latitude;
      double lon = _pickedLocation!.longitude;
      String snapshotLocation =
          'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=1000x700&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lon&key=KEY';
      return snapshotLocation;
    }
  }

  bool _isGettingLocation = false;

  void _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=KEY');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      //TODO display an error message
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    double latitude = locationData.latitude!;
    double longitude = locationData.longitude!;

    _savePlace(latitude, longitude);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (pickedLocation != null) {
      _savePlace(pickedLocation.latitude, pickedLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'Choose the Image Location!',
      style: Theme.of(context).textTheme.bodyMedium!,
    );
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: _pickedLocation != null ? 0 : 0.4,
                  color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child:
              _isGettingLocation ? CircularProgressIndicator() : previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: Text('Get Current Location'),
              icon: Icon(Icons.location_on_outlined),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: Text('Get From Map'),
              icon: Icon(Icons.map_outlined),
            ),
          ],
        )
      ],
    );
  }
}
