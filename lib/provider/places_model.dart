import 'dart:io';
import 'dart:math';
import 'package:f09_recursos_nativos/models/place_location.dart';
import 'package:f09_recursos_nativos/service/realtime_db_service.dart';
import 'package:f09_recursos_nativos/utils/getAddressFromLatLng.dart';
import 'package:flutter/material.dart';
import 'package:f09_recursos_nativos/models/place.dart';
import 'package:f09_recursos_nativos/utils/db_util.dart';

class PlacesModel with ChangeNotifier {
  List<Place> _items = [];
  final RealtimeDatabaseService _realtimeDatabaseService = RealtimeDatabaseService();

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addPlace(String title, File img, String phone, String email, double latitude, double longitude) async {
    final address = await getAddressFromLatLng(latitude, longitude);
    final newPlace = Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      image: img,
      phone: phone,
      email: email,
      location: PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      ),
    );

    _items.add(newPlace);

    await DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'phone': newPlace.phone,
      'email': newPlace.email,
      'latitude': newPlace.location?.latitude ?? 0.0,
      'longitude': newPlace.location?.longitude ?? 0.0,
      'address': newPlace.location?.address ?? '',
    });

    await _realtimeDatabaseService.addPlace(newPlace);
    notifyListeners();
  }

  Future<void> updatePlace(Place place) async {
    final index = _items.indexWhere((element) => element.id == place.id);
    if (index >= 0) {
      _items[index] = place;

      await DbUtil.insert('places', {
        'id': place.id,
        'title': place.title,
        'image': place.image.path,
        'phone': place.phone,
        'email': place.email,
        'latitude': place.location?.latitude ?? 0.0,
        'longitude': place.location?.longitude ?? 0.0,
        'address': place.location?.address ?? '',
      });

      await _realtimeDatabaseService.updatePlace(place);
      notifyListeners();
    }
  }

  Future<void> deletePlace(String id) async {
    final existingPlaceIndex = _items.indexWhere((place) => place.id == id);
    if (existingPlaceIndex >= 0) {
      final existingPlace = _items[existingPlaceIndex];
      _items.removeAt(existingPlaceIndex);
      notifyListeners();

      await DbUtil.delete('places', id);
      await _realtimeDatabaseService.deletePlace(id);
    }
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList.map((item) => Place(
      id: item['id'],
      title: item['title'],
      image: File(item['image']),
      phone: item['phone'],
      email: item['email'],
      location: PlaceLocation(
        latitude: item['latitude'] ?? 0.0,
        longitude: item['longitude'] ?? 0.0,
        address: item['address'] ?? '',
      ),
    )).toList();

    notifyListeners();
  }

  Future<void> syncPlaces() async {
    final remotePlaces = await _realtimeDatabaseService.fetchPlaces();
    final localPlaces = await DbUtil.getData('places');

    for (var place in remotePlaces) {
      if (!localPlaces.any((localPlace) => localPlace['id'] == place.id)) {
        await DbUtil.insert('places', {
          'id': place.id,
          'title': place.title,
          'image': place.image.path,
          'phone': place.phone,
          'email': place.email,
          'latitude': place.location?.latitude ?? 0.0,
          'longitude': place.location?.longitude ?? 0.0,
          'address': place.location?.address ?? '',
        });
      }
    }

    loadPlaces();
  }
}
