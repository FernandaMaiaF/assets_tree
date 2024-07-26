import 'package:assets_tree/models/company_model.dart';
import 'package:assets_tree/providers/company_provider.dart';
import 'package:assets_tree/screens/assets_screen.dart';
import 'package:assets_tree/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  var isInit = true;
  List<Company> companys = [];

  @override
  void didChangeDependencies() {
    if (isInit) _loadRequiredData();
    super.didChangeDependencies();
  }

  Future<void> _loadRequiredData() async {
    setState(() {
      isLoading = true;
    });

    List<Company> companysTmp = await CompanyProvider.getCompanys();

    setState(() {
      companys = companysTmp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/images/logo.png'),
          height: 17,
          color: Color(0xFFFFFFFF),
        ),
      ),
      body: isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: companys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: const Icon(Icons.business_sharp),
                          title: Text(companys[index].name),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AssetScreen.routName,
                                arguments: companys[index]);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
