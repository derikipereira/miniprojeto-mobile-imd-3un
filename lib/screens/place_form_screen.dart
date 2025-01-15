import 'dart:io';
import 'package:f09_recursos_nativos/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f09_recursos_nativos/components/image_input.dart';
import 'package:f09_recursos_nativos/components/location_input.dart';
import 'package:f09_recursos_nativos/provider/places_model.dart';
import 'package:f09_recursos_nativos/models/place.dart';
import 'package:f09_recursos_nativos/utils/app_routes.dart';

class PlaceFormScreen extends StatefulWidget {
  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  File? _pickedImage;
  double? _latitude;
  double? _longitude;

  Place? _editedPlace;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editedPlace == null) {
      final place = ModalRoute.of(context)?.settings.arguments as Place?;
      if (place != null) {
        _editedPlace = place;
        _titleController.text = place.title;
        _phoneController.text = place.phone;
        _emailController.text = place.email;
        _addressController.text = place.location!.address;
        _pickedImage = place.image;
        _latitude = place.location?.latitude;
        _longitude = place.location?.longitude;
      }
    }
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLocation(double latitude, double longitude, String address) {
    _latitude = latitude;
    _longitude = longitude;
    _addressController.text = address;
  }

  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty || _pickedImage == null || _phoneController.text.isEmpty || _emailController.text.isEmpty || _addressController.text.isEmpty || _latitude == null || _longitude == null) {
      return;
    }

    if (_editedPlace != null) {
      final updatedPlace = Place(
        id: _editedPlace!.id,
        title: _titleController.text,
        image: _pickedImage!,
        phone: _phoneController.text,
        email: _emailController.text,
        location: PlaceLocation(
          latitude: _latitude!,
          longitude: _longitude!,
          address: _addressController.text,
        ),
      );
      await Provider.of<PlacesModel>(context, listen: false).updatePlace(updatedPlace);
    } else {
      await Provider.of<PlacesModel>(context, listen: false).addPlace(
        _titleController.text,
        _pickedImage!,
        _phoneController.text,
        _emailController.text,
        _latitude!,
        _longitude!,
      );
    }

    Navigator.of(context).pop();
  }

  Future<void> _searchAddress() async {
    final result = await Navigator.of(context).pushNamed(AppRoutes.SEARCH_ADDRESS);
    if (result != null) {
      final location = result as PlaceLocation;
      _latitude = location.latitude;
      _longitude = location.longitude;
      _addressController.text = location.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedPlace == null ? 'Novo Lugar' : 'Editar Lugar', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    SizedBox(height: 10),
                    ImageInput(this._selectImage, initialImage: _pickedImage),
                    SizedBox(height: 10),
                    LocationInput(this._selectLocation),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Número de Contato'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'E-mail'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(labelText: 'Endereço'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchAddress,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(_editedPlace == null ? Icons.add : Icons.edit),
              label: Text(_editedPlace == null ? 'Adicionar' : 'Editar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }
}
