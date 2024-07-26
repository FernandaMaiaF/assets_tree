import 'package:flutter/material.dart';

class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('No results found'),
      ),
    );
  }
}
