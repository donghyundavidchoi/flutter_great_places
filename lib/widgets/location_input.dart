import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({
    super.key,
    required this.onSelectPlace,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  void _showPreview(double latitude, double longitude) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLoccation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selecOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLoccation,
              icon: const Icon(Icons.location_on),
              label: Text(
                'Current Location',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(
              width: 28,
            ),
            TextButton.icon(
              onPressed: _selecOnMap,
              icon: const Icon(Icons.map),
              label: Text(
                'Selet on Map',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
