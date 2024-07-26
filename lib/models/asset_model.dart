import 'dart:convert';

import 'package:assets_tree/models/location_model.dart';
import 'package:flutter/services.dart';

class Asset {
  String name;
  String id;
  String? locationId;
  String? parentId;
  String? sensorType;
  String? status;
  List<Asset> assets;
  List<Location> childLocations;

  Asset({
    required this.name,
    required this.id,
    required this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
    this.assets = const [],
    this.childLocations = const [],
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      name: json['name'],
      id: json['id'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }

  static Future<String> getAssetsDataJson(String path) async {
    return await rootBundle.loadString('assets/companys/$path/assets.json');
  }

  static Future<List<Asset>> getAssets(String path) async {
    List<Asset> assets = [];
    String assetsDataString = await Asset.getAssetsDataJson(path);
    final assetsJson = json.decode(assetsDataString);
    assetsJson.forEach((value) {
      assets.add(Asset.fromJson(value));
    });
    return assets;
  }

  static Asset getChildrenAssets(Asset parentAsset, List<Asset> assets) {
    List<Asset> childrenAssets =
        assets.where((element) => element.parentId == parentAsset.id).toList();
    parentAsset.assets = [];
    for (Asset childAsset in childrenAssets) {
      parentAsset.assets.add(Asset.getChildrenAssets(childAsset, assets));
    }
    return parentAsset;
  }

  static List<Asset> getLocChildrenAssets(
      Location location, List<Asset> assets) {
    List<Asset> childrenAssets =
        assets.where((element) => element.locationId == location.id).toList();
    location.assets = [];
    for (Asset childAsset in childrenAssets) {
      location.assets.add(Asset.getChildrenAssets(childAsset, assets));
    }
    return location.assets;
  }

  static bool existInChild(List<Asset> list, String search) {
    for (Asset asset in list) {
      if (asset.name.toLowerCase().contains(search)) {
        return true;
      }
      if (asset.assets.isNotEmpty) {
        if (Asset.existInChild(asset.assets, search)) {
          return true;
        }
      }
    }
    return false;
  }

  static List<Asset> serachAsset(List<Asset> assets, String search) {
    List<Asset> results = [];

    for (var asset in assets) {
      if (asset.name.toLowerCase().contains(search)) {
        results.add(asset); 
      }

      results.addAll(findSubtreesInChildren(asset, search));
    }

    return results;
  }

  static List<Asset> findSubtreesInChildren(Asset asset, String search) {
    List<Asset> results = [];

    for (var child in asset.assets) {
      if (child.name.toLowerCase().contains(search)) {
        results.add(child); 
      }
      results.addAll(findSubtreesInChildren(child, search));
    }

    return results;
  }
}
