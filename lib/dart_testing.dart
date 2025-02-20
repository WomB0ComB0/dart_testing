import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'firebase_service.dart';
import 'resource_model.dart' as resource_model;

final FirebaseService _firebaseService = FirebaseService.instance;

Future<void> importResourcesFromExcel(
    String filePath, String googleMapsApiKey) async {

  final file = File(filePath);
  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  final sheet = excel.tables[excel.tables.keys.first];
  final rows = sheet?.rows.sublist(1) ?? []; // Skip header row

  final resourcesRef =
      _firebaseService.firestore.collection('test').withConverter<resource_model.Resource>(
            fromFirestore: (snapshot,) => resource_model. Resource.fromJson(snapshot.data()),
            toFirestore: (resource,) => resource.toJson(),
          );

  for (final row in rows) {
    final paddedRow =
        row.length >= 8 ? row : [...row, ...List.filled(8 - row.length, null)];

    final resource = resource_model.Resource(
      id: const Uuid().v4(),
      sourceService: paddedRow[0]?.value.toString().trim() ?? 'Unknown Service',
      contact: paddedRow[1]?.value.toString().trim(),
      agencyProvider:
          paddedRow[2]?.value.toString().trim() ?? 'Unknown Provider',
      website: paddedRow[3]?.value.toString().trim(),
      address: paddedRow[4]?.value.toString().trim(),
      information: paddedRow[6]?.value.toString().trim(),
      hoursOfOperation:
          paddedRow[7]?.value.toString().trim() ?? 'Hours not specified',
    );

    var latitude = double.tryParse(paddedRow[5]?.value.toString() ?? '');
    var longitude = double.tryParse(paddedRow[6]?.value.toString() ?? '');

    // Geocode address if coordinates are missing
    if ((latitude == null || longitude == null) && resource.address != null) {
      try {
        final coordinates =
            await _geocodeAddress(resource.address!, googleMapsApiKey);
        latitude = coordinates.$1;
        longitude = coordinates.$2;
      } catch (e) {
        continue;
      }
    }

    if (latitude == null || longitude == null) {
      continue;
    }

    // Create resource with coordinates
    final resourceWithLocation = resource.copyWith(
      coordinates: resource_model.GeoPoint(latitude, longitude),
    );

    try {
      await resourcesRef.doc(resource.id).set(resourceWithLocation);
    } catch (e) {
      print('Error saving resource: $e');
    }
  }
}

Future<(double, double)> _geocodeAddress(String address, String apiKey) async {
  final encodedAddress = Uri.encodeComponent(address);
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body) as Map<String, dynamic>;

  if (data['status'] != 'OK') {
    throw Exception('Geocoding failed: ${data['status']}');
  }

  final location = data['results'][0]['geometry']['location'];
  return (location['lat'] as double, location['lng'] as double);
}
