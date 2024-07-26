
import 'package:assets_tree/models/company_model.dart';
import 'package:assets_tree/models/location_model.dart';

import '../models/asset_model.dart';

class CompanyProvider {
  static Future<List<Company>> getCompanys() async {
    List<Company> companysTmp = Company.companys;
    return companysTmp;
  }

  static Future<List<Location>> processData(
      List<Location> locations, List<Asset> assetsList) async {
    List<Location> locationsParent =
        locations.where((element) => element.parentId == null).toList();
    List<Location> locationsChilds =
        locations.where((element) => element.parentId != null).toList();

    for (Location parentLocation in locationsParent) {
      if (assetsList.isNotEmpty) {
        parentLocation.assets = assetsList
            .where((element) => element.locationId == parentLocation.id)
            .toList();
      }
      parentLocation = Location.getChildrenLocations(
          parentLocation, locationsChilds, assetsList);
    }
    return locationsParent;
  }

  static Future<Company> getCompanyData(String company) async {
    List<Asset> assetsList = await Asset.getAssets(company);
    List<Location> locationsList = await Location.getLocations(company);

    Company companyTmp = Company(
      name: company,
      assets: assetsList
          .where((element) =>
              element.parentId == null && element.locationId == null)
          .toList(),
      locations: await processData(locationsList, assetsList),
    );

    return companyTmp;
  }
}
