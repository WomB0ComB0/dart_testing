/// {@template resource_model}
/// Model class representing a resource or service provider in the system.
///
/// This model includes core resource information such as:
/// - Source service identifier
/// - Agency/provider details
/// - Operating hours
/// - Contact information
/// - Website URL
/// - Physical address
/// - Additional information
/// - Geographic location (coordinates and geohash)
///
/// The class uses [JsonSerializable] for JSON serialization/deserialization
/// and includes custom conversion for [GeoPoint] coordinates and [GeoHash] fields.
///
/// Example:
/// ```dart
/// final resource = Resource(
///   sourceService: 'food_bank',
///   agencyProvider: 'Local Food Bank',
///   hoursOfOperation: 'Mon-Fri 9am-5pm',
///   contact: '555-123-4567',
///   website: 'www.foodbank.org',
///   address: '123 Main St',
///   coordinates: GeoPoint(37.4219999, -122.0840575),
/// );
///
/// // Serialize to JSON
/// final json = resource.toJson();
///
/// // Deserialize from JSON
/// final resourceFromJson = Resource.fromJson(json);
/// ```
/// {@endtemplate}
library;

import 'package:dart_geohash/dart_geohash.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resource_model.g.dart';

class GeoPointConverter
    implements JsonConverter<GeoPoint?, Map<String, dynamic>?> {
  /// Creates a const [GeoPointConverter] instance.
  const GeoPointConverter();

  /// Converts a JSON map to a [GeoPoint] object.
  ///
  /// Takes a [Map<String, dynamic>] containing 'latitude' and 'longitude' keys
  /// and returns a [GeoPoint] instance. Returns null if the input map is null.
  ///
  /// The input map must have the following structure:
  /// ```dart
  /// {
  ///   'latitude': double,
  ///   'longitude': double
  /// }
  /// ```
  @override
  GeoPoint? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return GeoPoint(
      json['latitude'] as double,
      json['longitude'] as double,
    );
  }

  /// Converts a [GeoPoint] object to a JSON map.
  ///
  /// Takes a [GeoPoint] instance and returns a [Map<String, dynamic>] containing
  /// 'latitude' and 'longitude' keys. Returns null if the input GeoPoint is null.
  ///
  /// The output map has the following structure:
  /// ```dart
  /// {
  ///   'latitude': double,
  ///   'longitude': double
  /// }
  /// ```
  @override
  Map<String, dynamic>? toJson(GeoPoint? geoPoint) {
    if (geoPoint == null) return null;
    return {
      'latitude': geoPoint.latitude,
      'longitude': geoPoint.longitude,
    };
  }
}

@JsonSerializable()
class GeoPoint {
  /// Creates a new [GeoPoint] instance.
  ///
  /// [latitude] is the latitude of the point.
  /// [longitude] is the longitude of the point.
  GeoPoint(this.latitude, this.longitude);

  // Creates a [GeoPoint] from JSON
  factory GeoPoint.fromJson(Map<String, dynamic> json) =>
      _$GeoPointFromJson(json);

  /// The latitude of the point.
  final double latitude;

  /// The longitude of the point.
  final double longitude;

  /// Converts this [GeoPoint] to JSON.
  Map<String, dynamic> toJson() => _$GeoPointToJson(this);
}

/// {@template resource_model}
/// Model class representing a resource or service provider in the system.
/// {@endtemplate}
@JsonSerializable()
class Resource {
  /// Creates a new [Resource] instance.
  ///
  /// [sourceService] identifies the service type or category.
  /// [agencyProvider] is the name of the organization providing the service.
  /// [hoursOfOperation] specifies when the resource is available.
  /// [contact] is optional contact information.
  /// [website] is the optional URL for more information.
  /// [address] is the optional physical location.
  /// [information] contains any additional details.
  /// [coordinates] is the optional geographic location.
  /// [geohash] is the optional geohash encoding of the coordinates.
  Resource({
    required this.id,
    required this.sourceService,
    required this.agencyProvider,
    required this.hoursOfOperation,
    this.contact,
    this.website,
    this.address,
    this.information,
    this.coordinates,
    this.geohash,
  });

  /// Creates a [Resource] from a JSON map.
  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);

  /// The unique identifier for the resource
  final String id;

  /// The type or category of service provided
  final String sourceService;

  /// Contact information for the resource
  final String? contact;

  /// Name of the organization providing the service
  final String agencyProvider;

  /// Website URL for more information
  final String? website;

  /// Physical address of the resource
  final String? address;

  /// Additional details about the resource
  final String? information;

  /// Hours when the resource is available
  final String hoursOfOperation;

  /// Geographic coordinates of the resource location
  @GeoPointConverter()
  final GeoPoint? coordinates;

  /// Geohash encoding of the geographic coordinates
  @JsonKey(
    fromJson: _geohashFromJson,
    toJson: _geohashToJson,
  )
  final GeoHash? geohash;

  /// Converts this [Resource] instance to a JSON map.
  Map<String, dynamic> toJson() => _$ResourceToJson(this);

  /// Creates a [GeoHash] from its string representation.
  ///
  /// Returns null if the input string is null.
  static GeoHash? _geohashFromJson(String? json) {
    if (json == null) return null;
    return GeoHash(json);
  }

  /// Converts a [GeoHash] instance to its string representation.
  ///
  /// Returns null if the instance is null.
  static String? _geohashToJson(GeoHash? instance) {
    return instance?.geohash;
  }

  /// Creates a copy of this [Resource] with the specified coordinates.
  ///
  /// Returns a new [Resource] instance with all fields from the current instance,
  /// but with the provided [coordinates] value.
  Resource copyWith({required GeoPoint coordinates}) {
    return Resource(
      id: id,
      sourceService: sourceService,
      agencyProvider: agencyProvider,
      hoursOfOperation: hoursOfOperation,
      contact: contact,
      website: website,
      address: address,
      information: information,
      coordinates: coordinates,
      // ignore: unnecessary_null_comparison
      geohash: coordinates != null
          ? GeoHash.fromDecimalDegrees(
              coordinates.longitude,
              coordinates.latitude,
            )
          : null,
    );
  }
}
