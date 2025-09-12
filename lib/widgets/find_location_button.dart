import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';

class FindLocationButton extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? locationName;

  const FindLocationButton({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.locationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());

    return Obx(() => ElevatedButton.icon(
      onPressed: locationController.isLoading.value 
          ? null 
          : () async {
              await locationController.openGoogleMaps(
                latitude: latitude,
                longitude: longitude,
                locationName: locationName,
              );
            },
      icon: locationController.isLoading.value
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.location_on),
      label: Text(
        locationController.isLoading.value ? 'Opening...' : 'Find Location',
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ));
  }
}
