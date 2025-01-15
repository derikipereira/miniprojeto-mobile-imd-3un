import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, double>> getLatLngFromAddress(String address) async {
  final apiKey = 'AIzaSyAQJpKbMw1KwgeNl38WimhBrb_OSmPQrCc';
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeQueryComponent(address)}&key=$apiKey';

  final response = await http.get(Uri.parse(url));
  final data = json.decode(response.body);

  if (data['status'] == 'OK') {
    final location = data['results'][0]['geometry']['location'];
    return {
      'latitude': location['lat'],
      'longitude': location['lng'],
    };
  } else {
    throw Exception('Failed to fetch latitude and longitude');
  }
}
