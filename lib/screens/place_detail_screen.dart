import 'package:flutter/material.dart';
import 'package:f09_recursos_nativos/models/place.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)?.settings.arguments as Place;

    Future<void> _openMap() async {
      final url = 'https://www.google.com/maps/search/?api=1&query=${place.location?.latitude},${place.location?.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<void> _makePhoneCall() async {
      final url = 'tel:${place.phone}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<void> _sendEmail() async {
      final url = 'mailto:${place.email}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _makePhoneCall,
                    child: Text(
                      'Telefone: ${place.phone}',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _sendEmail,
                    child: Text(
                      'Email: ${place.email}',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Endereço: ${place.location?.address}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _openMap,
                    child: Image.network(
                      'https://maps.googleapis.com/maps/api/staticmap?center=${place.location?.latitude},${place.location?.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${place.location?.latitude},${place.location?.longitude}&key=AIzaSyAQJpKbMw1KwgeNl38WimhBrb_OSmPQrCc',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
