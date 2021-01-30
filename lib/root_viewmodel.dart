import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_webview_test/provider_page.dart';
import 'package:flutter_app_webview_test/tabbar_icon.dart';
import 'package:flutter_app_webview_test/unknow_page.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'value_util.dart';

class TabBarItem {
  String pagePath;
  String text;
  String name;
  String iconPath;
  String selectedIconPath;

  TabBarItem.fromMap(Map json) {
    pagePath = ValueUtil.toStr(json['pagePath']);
    text = ValueUtil.toStr(json['text']);
    name = ValueUtil.toStr(json['name']);
    iconPath = ValueUtil.toStr(json['iconPath']);
    selectedIconPath = ValueUtil.toStr(json['selectedIconPath']);
  }
}

class Screen {
  final TabBarItem item;
  final ScrollController scrollController;

  Screen({
    @required this.item,
    this.scrollController,
  });
}

class TabBarConfig {
  String color;
  String selectedColor;
  String backgroundColor;

  TabBarConfig.fromMap(Map json) {
    color = ValueUtil.toStr(json['color']);
    selectedColor = ValueUtil.toStr(json['selectedColor']);
    backgroundColor = ValueUtil.toStr(json['backgroundColor']);
  }
}

class DataTabBar {
  String name;

  TabBarConfig config;

  List<TabBarItem> data;

  DataTabBar.from(Map json) {
    name = ValueUtil.toStr(json['name']);
    config = TabBarConfig.fromMap(ValueUtil.toMap(json['config']));

    data = ValueUtil.toList(json['data'])
        .map((e) => TabBarItem.fromMap(ValueUtil.toMap(e)))
        .toList();
  }
}

class AppInfo {
  String id;
  String companyId;
  int indexType;
  int isEnforceSync;
  int isOpenRecommend;
  int isOpenWechatappLocation;
  int isOpenScanQrcode;
  int isOpenOfficialAccount;

  DataTabBar tabBar;

  AppInfo.fromMap(Map map) {
    id = ValueUtil.toStr(map['id']);
    companyId = ValueUtil.toStr(map['company_id']);
    indexType = ValueUtil.toInt(map['index_type']);
    isEnforceSync = ValueUtil.toInt(map['is_enforce_sync']);
    isOpenRecommend = ValueUtil.toInt(map['is_open_recommend']);
    isOpenWechatappLocation =
        ValueUtil.toInt(map['is_open_wechatapp_location']);
    isOpenScanQrcode = ValueUtil.toInt(map['is_open_scan_qrcode']);
    isOpenOfficialAccount = ValueUtil.toInt(map['is_open_official_account']);
    String strTabBar = ValueUtil.toStr(map['tab_bar']);
    tabBar = DataTabBar.from(json.decode(strTabBar));
  }
}

extension ScreenChild on Screen {
  Widget get child {
    switch (this.item.name) {
      case "home":
        return HomePage(
          key: UniqueKey(),
        );
      case "category":
        return ProviderPage();
      default:
        return UnknownPage(path: this.item.name);
    }
  }

  bool get isCart => this.item.name == "cart";
}

class RootViewModel extends ChangeNotifier {
  static RootViewModel of(BuildContext context) =>
      Provider.of<RootViewModel>(context, listen: false);
  List<BottomNavigationBarItem> get bottomNavigationBarItems =>
      _bottomNavigationBarItems;
  List<BottomNavigationBarItem> _bottomNavigationBarItems;

  List<Widget> _pages;
  List<Widget> get pages => _pages;

  final pageController = PageController();

  int _currentScreenIndex = 0;
  int get currentTabIndex => _currentScreenIndex;

  List<Screen> _screens = [];
  List<Screen> get screens => _screens;
  Screen get currentScreen => screens[_currentScreenIndex];

  AppInfo _info;
  AppInfo get info => _info;

  RootViewModel() {
    useLocalData();

    /// 预加载数据
    fetchTabs();
  }

  useLocalData() {
    Map data = {
      "id": "1",
      "company_id": "1",
      "index_type": 1,
      "is_enforce_sync": 2,
      "is_open_recommend": 2,
      "is_open_wechatapp_location": 2,
      "is_open_scan_qrcode": 2,
      "tab_bar":
          "{\"name\":\"tabs\",\"config\":{\"color\":\"#333333\",\"selectedColor\":\"#E03F1F\",\"backgroundColor\":\"#ffffff\"},\"data\":[{\"pagePath\":\"\/pages\/index\",\"text\":\"\u9996\u9875\",\"name\":\"home\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298uPyyA63Y1mU9bWZgpgcdMv8HXSTAkEZD\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298hfH2uzEIUosWakPeZL6rUIHGZTOJAPAX\"},{\"pagePath\":\"\/pages\/category\/index\",\"text\":\"\u5206\u7c7b\",\"name\":\"category\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298rSyZsHhoxrT03n8kxjM3p4ftdcDYDsNu\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298xNEjBbkatuJ82MdTxA3Eh6r1oB1aKerY\"},{\"pagePath\":\"\/pages\/cart\/espier-index\",\"text\":\"\u8d2d\u7269\u8f66\",\"name\":\"cart\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298r9V3Y0QWbt7N2E4I7RNC9tB1xEJpLhFI\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298QOVNpjwsln9WjyIMQdsaMkGirCdriIzs\"},{\"pagePath\":\"\/pages\/member\/index\",\"text\":\"\u6211\u7684\",\"name\":\"member\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298jV1DZCWvRg1KZvv1zvvJRViPl4TgjDVG\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc2987yEMJnKUFcP9vXyCTZpdoVilySf4rcHU\"}]}",
      "is_open_official_account": 2,
      "is_community_group": 0
    };
    configData(data);
    notifyListeners();
  }

  changeLang() {
    useLocalData();
  }

  fetchTabs() async {
    Future.delayed(Duration(seconds: 1), () {
      Map data = {
        "id": "1",
        "company_id": "1",
        "index_type": 1,
        "is_enforce_sync": 2,
        "is_open_recommend": 2,
        "is_open_wechatapp_location": 2,
        "is_open_scan_qrcode": 2,
        "tab_bar":
            "{\"name\":\"tabs\",\"config\":{\"color\":\"#333333\",\"selectedColor\":\"#E03F1F\",\"backgroundColor\":\"#ffffff\"},\"data\":[{\"pagePath\":\"\/pages\/index\",\"text\":\"\u9996\u9875\",\"name\":\"home\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298uPyyA63Y1mU9bWZgpgcdMv8HXSTAkEZD\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298hfH2uzEIUosWakPeZL6rUIHGZTOJAPAX\"},{\"pagePath\":\"\/pages\/category\/index\",\"text\":\"\u5206\u7c7b\",\"name\":\"category\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298rSyZsHhoxrT03n8kxjM3p4ftdcDYDsNu\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298xNEjBbkatuJ82MdTxA3Eh6r1oB1aKerY\"},{\"pagePath\":\"\/pages\/cart\/espier-index\",\"text\":\"\u8d2d\u7269\u8f66\",\"name\":\"cart\",\"iconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298r9V3Y0QWbt7N2E4I7RNC9tB1xEJpLhFI\",\"selectedIconPath\":\"https:\/\/image.umall.com.au\/image\/1\/2020\/12\/17\/852c1824e1b8b0f9babeda3bbbccc298QOVNpjwsln9WjyIMQdsaMkGirCdriIzs\"}]}",
        "is_open_official_account": 2,
        "is_community_group": 0
      };
      configData(data);
      notifyListeners();
    });
  }

  configData(Map data) {
    _info = AppInfo.fromMap(data);
    _screens = _info.tabBar.data.map((item) => Screen(item: item)).toList();
    _bottomNavigationBarItems = screens.map((screen) {
      return BottomNavigationBarItem(
        icon: RootTabBarIcon(
          iconPath: screen.item.iconPath,
        ),
        activeIcon: RootTabBarIcon(
          iconPath: screen.item.selectedIconPath,
        ),
        label: screen.item.text,
      );
    }).toList();
    _pages = screens.map((screen) => screen.child).toList();
  }

  /// Set currently visible tab.
  onPageChanged(int tab, BuildContext ctx) {
    _currentScreenIndex = tab;
    notifyListeners();
  }

  /// [userTap]用户手动点击
  barOnTap(int index, {bool userTap = true}) {
    pageController.jumpToPage(index);
  }
}
