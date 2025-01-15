import 'package:f09_recursos_nativos/utils/getLatLngFromAddress.dart';
import 'package:flutter/material.dart';
import 'package:f09_recursos_nativos/utils/getAddressFromLatLng.dart';
import 'package:f09_recursos_nativos/models/place_location.dart';

class SearchAddressScreen extends StatefulWidget {
  @override
  _SearchAddressScreenState createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> {
  final _addressController = TextEditingController();

  Future<void> _submitAddress() async {
    if (_addressController.text.isEmpty) {
      return;
    }

    final location = await getLatLngFromAddress(_addressController.text);
    if (location == null) {
      return;
    }

    final latitude = location['latitude'];
    final longitude = location['longitude'];

    if (latitude != null && longitude != null) {
      Navigator.of(context).pop(PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: _addressController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Endereço', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitAddress,
              child: Text('Buscar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
