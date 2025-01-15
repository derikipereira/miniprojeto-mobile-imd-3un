import 'dart:io';
import 'package:f09_recursos_nativos/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f09_recursos_nativos/provider/places_model.dart';
import 'package:f09_recursos_nativos/service/realtime_db_service.dart';
import 'package:f09_recursos_nativos/utils/app_routes.dart';

class PlacesListScreen extends StatelessWidget {
  final RealtimeDatabaseService _realtimeDatabaseService = RealtimeDatabaseService();

  Future<void> _syncPlaces(BuildContext context) async {
    await Provider.of<PlacesModel>(context, listen: false).syncPlaces();
  }

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Meus Lugares', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _syncPlaces(context),
            icon: Icon(Icons.sync, color: Colors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Gerência de Lugares', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Gerenciar Lugares'),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.MANAGE_PLACES);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<PlacesModel>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<PlacesModel>(
          child: Center(
            child: Text('Nenhum local'),
          ),
          builder: (context, places, child) => places.itemsCount == 0
              ? child!
              : ListView.builder(
            itemCount: places.itemsCount,
            itemBuilder: (context, index) {
              final place = places.itemByIndex(index);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: FileImage(place.image),
                ),
                title: Text(place.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (place.location != null) ...[
                      Text('Endereço: ${place.location!.address}'),
                      Text('Latitude: ${place.location!.latitude}'),
                      Text('Longitude: ${place.location!.longitude}'),
                    ],
                    Text('Telefone: ${place.phone}'),
                    Text('Email: ${place.email}'),
                  ],
                ),
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
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PLACE_DETAIL,
                    arguments: place,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
