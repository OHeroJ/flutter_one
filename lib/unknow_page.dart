import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  final String path;
  UnknownPage({@required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("$path路由不存在"),
      ),
    );
  }
}
