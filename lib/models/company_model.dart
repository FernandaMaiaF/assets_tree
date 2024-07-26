// ignore_for_file: constant_identifier_names

import 'package:assets_tree/models/asset_model.dart';
import 'package:assets_tree/models/location_model.dart';

class Company {
  String name;
  List<Asset> assets;
  List<Location> locations;
  Company(
      {required this.name, this.assets = const [], this.locations = const []});

  static const company_APEX = 'Apex Unit';
  static const company_JAGUAR = 'Jaguar Unit';
  static const company_TOBIAS = 'Tobias Unit';

  static List<Company> companys = [
    Company(name: company_APEX),
    Company(name: company_JAGUAR),
    Company(name: company_TOBIAS),
  ];
}
