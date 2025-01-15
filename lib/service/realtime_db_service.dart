import 'dart:io';
import 'package:f09_recursos_nativos/models/place_location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:f09_recursos_nativos/models/place.dart';

class RealtimeDatabaseService {
  final DatabaseReference _placesRef = FirebaseDatabase.instance.reference().child('places');

  Future<void> addPlace(Place place) async {
    try {
      await _placesRef.child(place.id).set({
        'id': place.id,
        'title': place.title,
        'image': place.image.path,
        'phone': place.phone,
        'email': place.email,
        'latitude': place.location?.latitude ?? 0.0,
        'longitude': place.location?.longitude ?? 0.0,
        'address': place.location?.address ?? '',
      });
      print('Place added successfully to Realtime Database');
    } catch (error) {
      print('Error adding place to Realtime Database: $error');
      throw error;
    }
  }

  Future<List<Place>> fetchPlaces() async {
    try {
      final snapshot = await _placesRef.once();
      final placesData = snapshot.snapshot.value as Map<dynamic, dynamic>;
      if (placesData != null) {
        final Map<String, dynamic> placesMap = Map<String, dynamic>.from(placesData);
        List<Place> places = [];
        placesMap.forEach((key, value) {
          places.add(Place(
            id: key,
            title: value['title'],
            image: File(value['image']),
            phone: value['phone'],
            email: value['email'],
            location: PlaceLocation(
              latitude: value['latitude'] ?? 0.0,
              longitude: value['longitude'] ?? 0.0,
              address: value['address'] ?? '',
            ),
          ));
        });
        return places;
      }
      return [];
    } catch (error) {
      print('Error fetching places from Realtime Database: $error');
      throw error;
    }
  }

  Future<void> updatePlace(Place place) async {
    try {
      await _placesRef.child(place.id).update({
        'title': place.title,
        'image': place.image.path,
        'phone': place.phone,
        'email': place.email,
        'latitude': place.location?.latitude ?? 0.0,
        'longitude': place.location?.longitude ?? 0.0,
        'address': place.location?.address ?? '',
      });
      print('Place updated successfully in Realtime Database');
    } catch (error) {
      print('Error updating place in Realtime Database: $error');
      throw error;
    }
  }

  Future<void> deletePlace(String id) async {
    try {
      await _placesRef.child(id).remove();
      print('Place removed successfully from Realtime Database');
    } catch (error) {
      print('Error removing place from Realtime Database: $error');
      throw error;
    }
  }
}
