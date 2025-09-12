import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  // Observable variables for loading state
  var isLoading = false.obs;

  // Method to open Google Maps with pin and navigation options
  Future<void> openGoogleMaps({
    required double latitude,
    required double longitude,
    String? locationName,
    bool startNavigation = false,
  }) async {
    try {
      isLoading.value = true;
      
      String googleMapsUrl;
      
      if (startNavigation) {
        // Direct navigation URL - opens turn-by-turn directions using exact coordinates
        googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
      } else {
        // Show location with pin using exact coordinates - will show address automatically
        googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      }

      final Uri url = Uri.parse(googleMapsUrl);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        
        if (startNavigation) {
          _showSuccessSnackbar('Starting navigation to destination...');
        } else {
          _showSuccessSnackbar('Opening location on map...');
        }
      } else {
        // Fallback to basic search URL
        final String fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(
            fallbackUri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          _showErrorSnackbar('Could not open Google Maps');
        }
      }
    } catch (e) {
      _showErrorSnackbar('Failed to open location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to open specific Kichanware location with pin
  Future<void> openKichanwareLocation() async {
    await openGoogleMaps(
      latitude: 22.222733126356857,
      longitude: 70.8079248819288,
      locationName: 'Dwarkesh Enterprise - Kitchen Ware Store',
      startNavigation: false,
    );
  }

  // Method to start navigation to Kichanware location
  Future<void> navigateToKichanwareLocation() async {
    await openGoogleMaps(
      latitude: 22.222733126356857,
      longitude: 70.8079248819288,
      locationName: 'Dwarkesh Enterprise - Kitchen Ware Store',
      startNavigation: true,
    );
  }

  // Method to show location options dialog
  void showLocationOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange[700], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Dwarkesh Enterprise',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Kitchen Ware Store',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.my_location, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Coordinates',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '22.222733126356857, 70.8079248819288',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // View on Map Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  openKichanwareLocation();
                },
                icon: const Icon(Icons.map),
                label: const Text('View on Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Start Navigation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  navigateToKichanwareLocation();
                },
                icon: const Icon(Icons.navigation),
                label: const Text('Start Navigation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to show success messages
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Helper method to show error messages
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
