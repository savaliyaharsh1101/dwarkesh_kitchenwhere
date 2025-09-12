import 'package:flutter/material.dart';
import '../widgets/find_location_button.dart';

class LocationExampleScreen extends StatelessWidget {
  const LocationExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Click the button below to open Google Maps with the specific location:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Coordinates: 22.222733126356857, 70.8079248819288',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            FindLocationButton(
              latitude: 22.222733126356857,
              longitude: 70.8079248819288,
              locationName: 'Dwarkesh Enterprise - Kitchen Ware Store', // Updated location name
            ),
          ],
        ),
      ),
    );
  }
}
