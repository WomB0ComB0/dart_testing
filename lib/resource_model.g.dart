// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoPoint _$GeoPointFromJson(Map<String, dynamic> json) => GeoPoint(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoPointToJson(GeoPoint instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource(
      id: json['id'] as String,
      sourceService: json['sourceService'] as String,
      agencyProvider: json['agencyProvider'] as String,
      hoursOfOperation: json['hoursOfOperation'] as String,
      contact: json['contact'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      information: json['information'] as String?,
      coordinates: const GeoPointConverter()
          .fromJson(json['coordinates'] as Map<String, dynamic>?),
      geohash: Resource._geohashFromJson(json['geohash'] as String?),
    );

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'id': instance.id,
      'sourceService': instance.sourceService,
      'contact': instance.contact,
      'agencyProvider': instance.agencyProvider,
      'website': instance.website,
      'address': instance.address,
      'information': instance.information,
      'hoursOfOperation': instance.hoursOfOperation,
      'coordinates': const GeoPointConverter().toJson(instance.coordinates),
      'geohash': Resource._geohashToJson(instance.geohash),
    };
