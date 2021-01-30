import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_webview_test/u_webview.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String url;
  @override
  void initState() {
    super.initState();
    url = "https://oldbird.run";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Stack(
        children: [
          FWebView(
            url: url,
            onDataLoaded: () {
              debugPrint("👌 onDataLoaded");
            },
          ),
          Positioned(
            child: Container(
              color: Colors.green.withOpacity(0.5),
              width: MediaQuery.of(context).size.width,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text('url: $url'),
            ),
            top: 0,
            left: 0,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
