import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/find_location_button.dart';
import '../controllers/location_controller.dart';

class SimpleLocationUsage extends StatelessWidget {
  const SimpleLocationUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Usage Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Method 1: Using the reusable widget
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Method 1: Using FindLocationButton Widget',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    FindLocationButton(
                      latitude: 22.222733126356857,
                      longitude: 70.8079248819288,
                      locationName: 'Dwarkesh Enterprise - Kitchen Ware Store',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Method 2: Using controller directly with custom button
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Method 2: Using LocationController Directly',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => ElevatedButton.icon(
                      onPressed: locationController.isLoading.value
                          ? null
                          : () {
                              locationController.showLocationOptions();
                            },
                      icon: locationController.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.store),
                      label: Text(
                        locationController.isLoading.value 
                            ? 'Opening Maps...' 
                            : 'Visit Our Store',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Method 3: Simple text button
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Method 3: Simple Text Button',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () async {
                        await locationController.openKichanwareLocation();
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text('Get Directions'),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Information card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'How it works:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Clicking any button will open Google Maps\\n'
                    '• The location will be pinned at your coordinates\\n'
                    '• Works on both Android and iOS devices\\n'
                    '• Falls back gracefully if Maps isn\\'t available',
                    style: TextStyle(color: Colors.blue),
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
