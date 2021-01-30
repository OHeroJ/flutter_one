import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_webview_test/root_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RootViewModel(),
      builder: (context, child) => Consumer<RootViewModel>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: PageView.builder(
              itemBuilder: (ctx, index) => provider.pages[index],
              itemCount: provider.pages.length,
              controller: provider.pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) => provider.onPageChanged(index, context),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: provider.info.tabBar.config.selectedColor.toColor(),
              unselectedItemColor: provider.info.tabBar.config.color.toColor(),
              backgroundColor: provider.info.tabBar.config.backgroundColor.toColor(),
              items: provider.bottomNavigationBarItems,
              currentIndex: provider.currentTabIndex,
              onTap: provider.barOnTap,
              selectedFontSize: 10,
              unselectedFontSize: 10,
            ),
          );
        },
      ),
    );
  }
}

extension StringExt on String {
  /// 将 '#333333' 转化为颜色 '#333333'.toColor()
  Color toColor() {
    String hex = this.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  String get u_phone_hide {
    if (this == null || this.length <= 4) {
      return this;
    }
    return this.replaceRange(2, this.length - 4, "****");
  }
}
