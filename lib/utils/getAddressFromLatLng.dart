import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  final apiKey = 'AIzaSyAQJpKbMw1KwgeNl38WimhBrb_OSmPQrCc';
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

  final response = await http.get(Uri.parse(url));
  final data = json.decode(response.body);

  if (data['status'] == 'OK') {
    return data['results'][0]['formatted_address'];
  } else {
    throw Exception('Failed to fetch address');
  }
}
