import 'package:assets_tree/models/asset_model.dart';
import 'package:assets_tree/models/company_model.dart';
import 'package:assets_tree/models/location_model.dart';
import 'package:assets_tree/providers/company_provider.dart';
import 'package:assets_tree/widgets/loading_widget.dart';
import 'package:assets_tree/widgets/no_results_widget.dart';
import 'package:flutter/material.dart';

class AssetScreen extends StatefulWidget {
  static const routName = '/asset';
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  var isLoading = true;
  var isInit = true;
  Company? selectedCompany;
  List<Asset> assetsParents = [];

  final TextEditingController _textEditingController = TextEditingController();
  List<Asset> filteredAsset = [];
  List<Location> filteredLocation = [];
  @override
  void didChangeDependencies() {
    if (isInit) _loadRequiredData();
    super.didChangeDependencies();
  }

  Future<void> _loadRequiredData() async {
    setState(() {
      isLoading = true;
    });
    Company? selectedCompanyTmp =
        ModalRoute.of(context)!.settings.arguments as Company?;
    if (selectedCompanyTmp != null) {
      selectedCompanyTmp =
          await CompanyProvider.getCompanyData(selectedCompanyTmp.name);
    }

    setState(() {
      selectedCompany = selectedCompanyTmp;
      isLoading = false;
    });
  }

  void searchItem(String serach) {
    serach = serach.toLowerCase();
    setState(() {
      filteredAsset =
          Asset.serachAsset(selectedCompany!.assets, serach.toLowerCase());
      filteredLocation = Location.serachLocation(
          selectedCompany!.locations, serach.toLowerCase());
    });
  }

  void clearSearch() {
    setState(() {
      _textEditingController.clear();
      filteredAsset = selectedCompany!.assets;
      filteredLocation = selectedCompany!.locations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Column(
          children: [
            const Text('Assets'),
            if (!isLoading)
              Text(
                selectedCompany?.name ?? '',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
      body: isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: selectedCompany == null
                  ? const NoResultsWidget()
                  : Column(
                      children: [
                        if (selectedCompany!.assets.isNotEmpty ||
                            selectedCompany!.locations.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                color: Color(0xFFEDEDF3),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            constraints: const BoxConstraints(maxHeight: 38),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                onChanged: searchItem,
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: clearSearch,
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                  ),
                                  hintText: 'Busar Ativo ou Local',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                ),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.flash_on_outlined),
                              style: TextButton.styleFrom(

                                foregroundColor: Theme.of(context).primaryColor,
                              ),
                              label: const Text('Sensor de Energia'),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.info),
                              label: const Text('Crítico'),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (!(_textEditingController.text.isNotEmpty &&
                            filteredLocation.isEmpty))
                          listLocations(filteredLocation.isEmpty
                              ? selectedCompany!.locations
                              : filteredLocation),
                        if (!(_textEditingController.text.isNotEmpty &&
                            filteredAsset.isEmpty))
                          listAssets(filteredAsset.isEmpty
                              ? selectedCompany!.assets
                              : filteredAsset),
                      ],
                    ),
            ),
    );
  }

  Widget listLocations(List<Location> locationList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: locationList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildExpandedLocationChild(locationList[index]),
          ),
        );
      },
    );
  }

  Widget listAssets(List<Asset> assetList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assetList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildExpandedAssetChild(assetList[index]),
          ),
        );
      },
    );
  }

  Widget buildExpandedAssetChild(Asset asset) {
    return ExpansionTile(
      title: RichText(
        text: TextSpan(
          text: '',
          children: [
            WidgetSpan(
                child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image(
                image: AssetImage(
                  (asset.sensorType == null || asset.sensorType == '')
                      ? 'assets/icons/assets_icon.png'
                      : 'assets/icons/component_icon.png',
                ),
              ),
            )),
            TextSpan(
              text: asset.name,
              style: const TextStyle(color: Colors.black),
            ),
            if (asset.status != null && asset.status == "alert")
              const WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0, bottom: 4),
                  child: Icon(Icons.circle, size: 10, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      leading: (asset.childLocations.isEmpty && asset.assets.isEmpty)
          ? const Text('')
          : null,
      controlAffinity: ListTileControlAffinity.leading,
      children: <Widget>[
        if (asset.childLocations.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: asset.childLocations.length,
            itemBuilder: (context, index) {
              return buildExpandedLocationChild(asset.childLocations[index]);
            },
          ),
        if (asset.assets.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: asset.assets.length,
            itemBuilder: (context, index) {
              return buildExpandedAssetChild(asset.assets[index]);
            },
          ),
      ],
    );
  }

  Widget buildExpandedLocationChild(Location location) {
    return ExpansionTile(
      title: RichText(
        text: TextSpan(
          text: '',
          children: [
            const WidgetSpan(
                child: Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Image(
                image: AssetImage('assets/icons/location_icon.png'),
              ),
            )),
            TextSpan(
              text: location.name,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      leading: (location.childLocations.isEmpty && location.assets.isEmpty)
          ? const Text('')
          : null,
      children: <Widget>[
        if (location.childLocations.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: location.childLocations.length,
            itemBuilder: (context, index) {
              return buildExpandedLocationChild(location.childLocations[index]);
            },
          ),
        if (location.assets.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: location.assets.length,
            itemBuilder: (context, index) {
              return buildExpandedAssetChild(location.assets[index]);
            },
          ),
      ],
    );
  }
}
