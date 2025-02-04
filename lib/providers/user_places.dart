import 'dart:io';

import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/repositories/database_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  static const String _tableName = 'places';
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final List<Map<String, Object?>> data = await DatabaseUtil().getTable(_tableName);
    final List<Place> places = data
        .map(
          (row) => Place(
            id: row['id'] as int,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    //Save image locally
    final Directory sysPath = await syspaths.getApplicationDocumentsDirectory();
    final String imgName = path.basename(image.path);
    final File savedImage = await image.copy('${sysPath.path}/$imgName');
    final place = {
      'title': title,
      'image': savedImage.path,
      'lat': location.latitude,
      'lng': location.longitude,
      'address': location.address,
    };
    final response = await DatabaseUtil().insert(_tableName, place);
    if (response['id'] == -1) {
      //TODO manage error
      return;
    }
    //Create Place
    final newPlace = Place(
      id: response['id'],
      title: title,
      image: savedImage,
      location: location,
    );
    state = [newPlace, ...state];
  }
}

final StateNotifierProvider<UserPlacesNotifier, List<Place>> userPlaceProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
