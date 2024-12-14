// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ev_homes/core/models/amenity.dart';
import 'package:ev_homes/core/models/configuration.dart';

class OurProject {
  final String? id;
  final String? name;
  final String? description;
  final String? showCaseImage;
  final List<String> carouselImages;
  final List<Configuration> configurations;
  final List<Amenity> amenities;
  final List<Flat> flatList;
  final List<Parking> parkingList;
  final String? locationName;
  final String? locationLink;
  final int? contactNumber;
  final String? brochure;
  final String? countryCode;

  OurProject({
    required this.id,
    required this.name,
    this.description = '',
    this.showCaseImage,
    this.carouselImages = const [],
    this.flatList = const [],
    this.parkingList = const [],
    this.configurations = const [],
    this.amenities = const [],
    this.locationName,
    this.locationLink,
    this.contactNumber,
    this.brochure,
    this.countryCode = "+91",
  });

  factory OurProject.fromJson(Map<String, dynamic> json) {
    // print(json["flatList"]);
    // print("parsed ourProject");
    return OurProject(
      id: json["_id"],
      name: json["name"] ?? '',
      locationName: json["locationName"] ?? '',
      locationLink: json["locationLink"] ?? '',
      description: json["description"] ?? '',
      showCaseImage: json["showCaseImage"] ?? '',
      contactNumber: json["contactNumber"] ?? 0,
      brochure: json["brochure"],
      countryCode: json["countryCode"] ?? "+91",
      carouselImages: List<String>.from(json["carouselImages"] ?? []),
      configurations: (json["configurations"] as List<dynamic>?)
              ?.map(
                  (ele) => Configuration.fromJson(ele as Map<String, dynamic>))
              .toList() ??
          [],
      amenities: (json["amenities"] as List<dynamic>?)
              ?.map(
                (ele) => Amenity.fromJson(ele as Map<String, dynamic>),
              )
              .toList() ??
          [],
      parkingList: (json["parkingList"] as List<dynamic>?)
              ?.map((ele) => Parking.fromMap(ele))
              .toList() ??
          [],
      flatList: (json["flatList"] as List<dynamic>?)
              ?.map((ele) => Flat.fromMap(ele))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "locationName": locationName,
      "locationLink": locationLink,
      "description": description,
      "showCaseImage": showCaseImage,
      "carouselImages": carouselImages,
      "contactNumber": contactNumber,
      "brochure": brochure,
      "countryCode": countryCode,
      "configurations": configurations.map((e) => e.toJson()).toList(),
      "amenities": amenities.map((e) => e.toJson()).toList(),
      "flatList": flatList.map((e) => e.toMap()).toList(),
      "parkingList": parkingList.map((e) => e.toMap()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OurProject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Flat {
  final String? type;
  final int? floor;
  final int? number;
  final String? flatNo;
  final int? carpetArea;
  final int? sellableCarpetArea;
  final double? allInclusiveValue;
  final bool? occupied;
  final String? occupiedBy;
  final String? configuration;
  final double? msp1;
  final double? msp2;
  final double? msp3;

  Flat({
    required this.type,
    required this.floor,
    required this.number,
    required this.flatNo,
    required this.carpetArea,
    required this.sellableCarpetArea,
    required this.allInclusiveValue,
    required this.occupied,
    required this.occupiedBy,
    required this.configuration,
    required this.msp1,
    required this.msp2,
    required this.msp3,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'floor': floor,
      'number': number,
      'flatNo': flatNo,
      'carpetArea': carpetArea,
      'sellableCarpetArea': sellableCarpetArea,
      'allInclusiveValue': allInclusiveValue,
      'occupied': occupied,
      'occupiedBy': occupiedBy,
      'configuration': configuration,
      'msp1': msp1,
      'msp2': msp2,
      'msp3': msp3,
    };
  }

  factory Flat.fromMap(Map<String, dynamic> map) {
    return Flat(
      type: map['type'],
      floor: map['floor'],
      number: map['number'],
      flatNo: map['flatNo'],
      carpetArea: map['carpetArea'],
      sellableCarpetArea: map['sellableCarpetArea'],
      allInclusiveValue: map['allInclusiveValue'] != null
          ? double.parse(map['allInclusiveValue'].toString())
          : map['allInclusiveValue'],
      occupied: map['occupied'],
      configuration: map['configuration'],
      occupiedBy: map['occupiedBy'],
      msp1: map['msp1'] != null
          ? double.parse(map['msp1'].toString())
          : map['msp1'],
      msp2: map['msp2'] != null
          ? double.parse(map['msp2'].toString())
          : map['msp2'],
      msp3: map['msp3'] != null
          ? double.parse(map['msp3'].toString())
          : map['msp3'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Flat.fromJson(String source) =>
      Flat.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Parking {
  final int? floor;
  final String? floorName;
  final String? parkingNo;
  final bool? occupied;
  final String? occupiedBy;

  Parking({
    required this.floor,
    required this.floorName,
    required this.parkingNo,
    required this.occupied,
    required this.occupiedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'floor': floor,
      'floorName': floorName,
      'parkingNo': parkingNo,
      'occupied': occupied,
      'occupiedBy': occupiedBy,
    };
  }

  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
      floor: map['floor'] != null ? map['floor'] as int : null,
      floorName: map['floorName'] != null ? map['floorName'] as String : null,
      parkingNo: map['parkingNo'] != null ? map['parkingNo'] as String : null,
      occupied: map['occupied'] != null ? map['occupied'] as bool : null,
      occupiedBy:
          map['occupiedBy'] != null ? map['occupiedBy'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Parking.fromJson(String source) =>
      Parking.fromMap(json.decode(source) as Map<String, dynamic>);
}
