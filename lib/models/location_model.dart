import 'dart:convert';

import 'package:assets_tree/models/asset_model.dart';
import 'package:flutter/services.dart';

class Location {
  final String name;
  final String id;
  final String? parentId;
  List<Asset> assets;
  List<Location> childLocations;

  Location({
    required this.name,
    required this.id,
    this.parentId,
    this.assets = const [],
    this.childLocations = const [],
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      id: json['id'],
      parentId: json['parentId'],
    );
  }

  static Future<String> getLocationsDataJson(String path) async {
    return await rootBundle.loadString('assets/companys/$path/locations.json');
  }

  static Future<List<Location>> getLocations(String path) async {
    List<Location> locations = [];
    String locationsDataString = await Location.getLocationsDataJson(path);
    final locationsJson = json.decode(locationsDataString);
    locationsJson.forEach((value) {
      locations.add(Location.fromJson(value));
    });
    return locations;
  }

  static Location getChildrenLocations(Location parentLocation, List<Location> locations, List<Asset> assetsList) {
    List<Location> childrenLocations = locations.where((element) => element.parentId == parentLocation.id).toList();
    parentLocation.childLocations = [];
    for (Location childLocation in childrenLocations) {
      parentLocation.childLocations.add(Location.getChildrenLocations(childLocation, locations, assetsList));
      if(assetsList.isNotEmpty){
        parentLocation.assets = assetsList.where((element) => element.locationId == childLocation.id).toList();
      }
    }
    return parentLocation;
  }


  static List<Location> serachLocation(List<Location> locations, String search) {
    List<Location> results = [];

    for (var location in locations) {
      if (location.name.toLowerCase().contains(search)) {
        results.add(location); // Found an asset, add it to the results list
      }

      // Recursively search in children
      results.addAll(findSubtreesInChildren(location, search));
      for(var asset in location.assets){
        location.assets = Asset.findSubtreesInChildren(asset, search);
      }
    }

    return results;
  }

  static List<Location> findSubtreesInChildren(Location location, String search) {
    List<Location> results = [];

    for (var child in location.childLocations) {
      if (child.name.toLowerCase().contains(search)) {
        results.add(child); // Found an asset, add it to the results list
      }

      // Recursively search in the child's children
      results.addAll(findSubtreesInChildren(child, search));
    }

    return results;
  }
}
