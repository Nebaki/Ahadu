import 'package:flutter/material.dart';
import '../noInternet.dart';
import 'networkAwareWidget .dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NetworkAwareWidget(
          onlineChild: child,
          offlineChild: NoInternet()),
    );
  }
}
