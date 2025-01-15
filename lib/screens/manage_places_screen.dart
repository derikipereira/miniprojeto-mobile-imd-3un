import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f09_recursos_nativos/provider/places_model.dart';
import 'package:f09_recursos_nativos/utils/app_routes.dart';

class ManagePlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Gerenciar Lugares', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<PlacesModel>(
        builder: (context, places, child) => ListView.builder(
          itemCount: places.itemsCount,
          itemBuilder: (context, index) {
            final place = places.itemByIndex(index);
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(place.image),
              ),
              title: Text(place.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.amber,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.PLACE_FORM,
                        arguments: place,
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () async {
                      await Provider.of<PlacesModel>(context, listen: false).deletePlace(place.id);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
