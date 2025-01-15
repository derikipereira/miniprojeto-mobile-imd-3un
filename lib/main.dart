import 'package:f09_recursos_nativos/screens/SearchAddressScreen.dart';
import 'package:f09_recursos_nativos/screens/registry_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:f09_recursos_nativos/provider/places_model.dart';
import 'package:f09_recursos_nativos/screens/place_form_screen.dart';
import 'package:f09_recursos_nativos/screens/place_detail_screen.dart';
import 'package:f09_recursos_nativos/screens/places_list_screen.dart';
import 'package:f09_recursos_nativos/screens/login_screen.dart';
import 'package:f09_recursos_nativos/screens/manage_places_screen.dart';
import 'package:f09_recursos_nativos/utils/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    return email != null && password != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoggedIn(),
      builder: (ctx, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final isLoggedIn = snapshot.data ?? false;
        return ChangeNotifierProvider(
          create: (context) => PlacesModel(),
          child: MaterialApp(
            title: 'My Places',
            theme: ThemeData().copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.indigo,
                secondary: Colors.amber,
              ),
            ),
            home: isLoggedIn ? PlacesListScreen() : LoginScreen(),
            routes: {
              AppRoutes.PLACE_FORM: (ctx) => PlaceFormScreen(),
              AppRoutes.PLACE_DETAIL: (ctx) => PlaceDetailScreen(),
              AppRoutes.SEARCH_ADDRESS: (ctx) => SearchAddressScreen(),
              AppRoutes.LOGIN: (ctx) => LoginScreen(),
              AppRoutes.REGISTER: (ctx) => RegisterScreen(),
              AppRoutes.PLACES_LIST: (ctx) => PlacesListScreen(),
              AppRoutes.MANAGE_PLACES: (ctx) => ManagePlacesScreen(),
            },
          ),
        );
      },
    );
  }
}
