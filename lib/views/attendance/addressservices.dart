import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  final String apiKey =
      'AIzaSyClsC0YHezhyCPENiQ4CFBmcLdF_Ycf8OQ'; // Replace with your Google API Key

  /// Get address from latitude and longitude
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');

    try {
      // Send GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final address = data['results'][0]['formatted_address'];
          return address;
        } else if (data['status'] == 'ZERO_RESULTS') {
          throw Exception("No address found for the provided coordinates.");
        } else {
          throw Exception("Error from API: ${data['status']}");
        }
      } else {
        throw Exception(
            "Failed to connect to the API. HTTP status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }
}
