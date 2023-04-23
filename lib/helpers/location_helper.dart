import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'AIzaSyAE5BYLXWUElt-2cCtOXYaMIO2X9YTmGzs';

class LocationHelper {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=14&size=400x400&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
